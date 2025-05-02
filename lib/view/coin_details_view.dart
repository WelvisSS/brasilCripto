import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrx_charts/mrx_charts.dart';

import '../data/response/status.dart';
import '../models/favorite_coin.dart';
import '../res/colors/colors.dart';
import '../shared/widgets/circular_countdown_timer.dart';
import '../shared/widgets/confirm_dialog.dart';
import '../utils/format_abbreviated_currency.dart';
import '../view_models/controllers/coin_details/coin_details_view_model.dart';
import 'error_view.dart';

class CoinDetailsView extends GetView<CoinDetailsController> {
  const CoinDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              controller.coinDetails.value?.image.small != null &&
                      controller.coinDetails.value!.image.small.isNotEmpty
                  ? Image.network(
                    controller.coinDetails.value!.image.small,
                    width: 24,
                    height: 24,
                  )
                  : Icon(
                    Icons.monetization_on,
                    color: AppColors.secondary,
                    size: 24,
                  ),
              const SizedBox(width: 8),
              Text(
                controller.name,
                style: TextStyle(color: AppColors.secondary),
              ),
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors.secondary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: Icon(
                controller.isFavorite.value ? Icons.star : Icons.star_border,
                color:
                    controller.isFavorite.value
                        ? AppColors.yellow
                        : AppColors.white,
              ),
              onPressed: () {
                if (controller.coinDetails.value?.symbol == null ||
                    controller.coinDetails.value?.image.small == null) {
                  return;
                }
                final coin = FavoriteCoin(
                  id: controller.coinId.value,
                  name: controller.coinName.value,
                  symbol: controller.coinDetails.value?.symbol ?? "",
                  image: controller.coinDetails.value?.image.small ?? "",
                );
                if (!controller.isFavorite.value) {
                  controller.favoriteController.addFavorite(coin);
                  controller.isFavorite.value = !controller.isFavorite.value;
                } else {
                  showDialog(
                    context: context,
                    builder:
                        (context) => ConfirmDialog(
                          title: 'Remover da lista',
                          message:
                              'Tem certeza que deseja remover dos favoritos?',
                          onConfirm: () {
                            controller.favoriteController.removeFavorite(
                              controller.coinId.value,
                            );
                            controller.isFavorite.value =
                                !controller.isFavorite.value;
                          },
                        ),
                  );
                }
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  controller.coinDetails.value?.image.small != null &&
                          controller.coinDetails.value!.image.small.isNotEmpty
                      ? Image.network(
                        controller.coinDetails.value!.image.small,
                        width: 20,
                        height: 20,
                      )
                      : Icon(
                        Icons.monetization_on,
                        color: AppColors.secondary,
                        size: 20,
                      ),
                  const SizedBox(width: 8),
                  Text(
                    controller.coinName.value,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                formatAbbreviatedCurrency(
                  controller.coinDetails.value?.marketData.marketCap["brl"] ??
                      0,
                  currencySymbol: "R\$",
                ),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Text(
                      "Últimas 30 dias",
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        controller.coinDetails.value?.image.small != null &&
                                controller
                                    .coinDetails
                                    .value!
                                    .image
                                    .small
                                    .isNotEmpty
                            ? Image.network(
                              controller.coinDetails.value!.image.small,
                              width: 20,
                              height: 20,
                            )
                            : Icon(
                              Icons.monetization_on,
                              color: AppColors.secondary,
                              size: 20,
                            ),
                        const SizedBox(width: 8),
                        Text(
                          formatAbbreviatedCurrency(
                            controller
                                    .coinDetails
                                    .value
                                    ?.marketData
                                    .currentPrice["brl"] ??
                                0,
                            currencySymbol: "R\$",
                          ),
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  CircularCountdownTimer(
                    seconds: 60,
                    onFinish: () {
                      controller.refreshApi();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Obx(() {
                  switch (controller.rxRequestStatus.value) {
                    case Status.LOADING:
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    case Status.ERROR:
                      return ErrorView(
                        message: controller.error.value,
                        onRetry: () => controller.refreshApi(),
                      );
                    case Status.COMPLETED:
                      return Column(
                        children: [
                          controller.chart.value != null
                              ? SizedBox(
                                height: 200,
                                child: Chart(
                                  padding: const EdgeInsets.only(left: 20),
                                  layers: [
                                    ChartAxisLayer(
                                      labelX: (_) => '',
                                      labelY: (value) {
                                        final prices =
                                            controller.chartData
                                                .map((e) => e.value)
                                                .toList();
                                        if (prices.isEmpty) return '';

                                        final min = prices.reduce(
                                          (a, b) => a < b ? a : b,
                                        );
                                        final max = prices.reduce(
                                          (a, b) => a > b ? a : b,
                                        );
                                        final step = (max - min) / 3;

                                        final labels = [
                                          min,
                                          min + step,
                                          min + step * 2,
                                          max,
                                        ];

                                        const tolerance = 0.015;

                                        for (final label in labels) {
                                          if ((value - label).abs() <
                                              tolerance * label) {
                                            return 'R\$ ${label.toStringAsFixed(0)}';
                                          }
                                        }
                                        return '';
                                      },
                                      settings: ChartAxisSettings(
                                        x: ChartAxisSettingsAxis(
                                          frequency: 1,
                                          min: 0,
                                          max:
                                              controller.chartData.length
                                                  .toDouble(),
                                          textStyle: const TextStyle(
                                            fontSize: 10,
                                            color: AppColors.gray,
                                          ),
                                        ),
                                        y: ChartAxisSettingsAxis(
                                          frequency:
                                              (controller.chartData
                                                      .map((e) => e.value)
                                                      .reduce(
                                                        (a, b) => a > b ? a : b,
                                                      ) -
                                                  controller.chartData
                                                      .map((e) => e.value)
                                                      .reduce(
                                                        (a, b) => a < b ? a : b,
                                                      )) /
                                              3,
                                          min: controller.chartData
                                              .map((e) => e.value)
                                              .reduce((a, b) => a < b ? a : b),
                                          max: controller.chartData
                                              .map((e) => e.value)
                                              .reduce((a, b) => a > b ? a : b),
                                          textStyle: const TextStyle(
                                            fontSize: 10,
                                            color: AppColors.gray,
                                          ),
                                        ),
                                      ),
                                    ),
                                    ChartLineLayer(
                                      settings: ChartLineSettings(
                                        color: AppColors.green,
                                        thickness: 2,
                                      ),
                                      items: controller.chartData,
                                    ),
                                  ],
                                ),
                              )
                              : const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              const Text(
                                "Descrição do projeto:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListView(
                              children: [
                                Text(
                                  controller
                                          .coinDetails
                                          .value
                                          ?.description
                                          .en ??
                                      "",
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
