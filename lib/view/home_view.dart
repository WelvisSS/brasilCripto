import 'package:brasil_cripto/repository/coin_chart_repository/coin_chart_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/network/network_api_services.dart';
import '../data/response/status.dart';
import '../repository/coin_details_repository/coin_details_repository.dart';
import '../res/colors/colors.dart';
import '../shared/widgets/circular_countdown_timer.dart';
import '../shared/widgets/confirm_dialog.dart';
import '../shared/widgets/sparkline_chart.dart';
import '../utils/format_abbreviated_currency.dart';
import '../utils/format_percentage_change.dart';
import '../view_models/controllers/coin_details/coin_details_view_model.dart';
import '../view_models/controllers/home/home_view_model.dart';
import 'coin_details_view.dart';
import 'error_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          children: [
            // Cabeçalho fixo
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Text(
                    "Top 10 moedas",
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Text(
                    "Últimas 24h",
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
                Spacer(),
                CircularCountdownTimer(
                  seconds: 60,
                  onFinish: () {
                    controller.refreshApi();
                  },
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    controller.selectedIndex.value = 1;
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: AppColors.secondary,
                        width: 1.0,
                      ),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: AppColors.secondary,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
                    return ListView.builder(
                      itemCount: controller.coinList.length,
                      itemBuilder: (context, index) {
                        final coin = controller.coinList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          color: AppColors.black,
                          child: ListTile(
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                  coin.image,
                                  width: 24,
                                  height: 24,
                                ),
                              ],
                            ),
                            title: Text(
                              coin.symbol,
                              style: TextStyle(color: AppColors.white),
                            ),
                            subtitle: Text(
                              formatAbbreviatedCurrency(coin.marketCap),
                              style: const TextStyle(
                                color: AppColors.secondary,
                              ),
                            ),
                            trailing: IntrinsicWidth(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '\$ ${coin.currentPrice.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.secondary,
                                        ),
                                      ),
                                      Text(
                                        formatPercentageChange(
                                          coin.marketCapChangePercentage24H,
                                        ),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              coin.marketCapChangePercentage24H <
                                                      0
                                                  ? AppColors.red
                                                  : AppColors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 8),
                                  SparklineChart(
                                    prices: coin.sparklineIn7D.price,
                                  ),
                                  const SizedBox(width: 16),
                                  Obx(
                                    () => InkWell(
                                      onTap: () {
                                        if (!controller.favoriteController
                                            .isFavorite(coin.id)) {
                                          controller.addFavorite(
                                            coin.id,
                                            coin.name,
                                            coin.image,
                                            coin.symbol,
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (context) => ConfirmDialog(
                                                  title: 'Remover da lista',
                                                  message:
                                                      'Tem certeza que deseja remover dos favoritos?',
                                                  onConfirm: () {
                                                    controller
                                                        .favoriteController
                                                        .removeFavorite(
                                                          coin.id,
                                                        );
                                                  },
                                                ),
                                          );
                                        }
                                      },
                                      child: Icon(
                                        controller.favoriteController
                                                .isFavorite(coin.id)
                                            ? Icons.star
                                            : Icons.star_border,
                                        color:
                                            controller.favoriteController
                                                    .isFavorite(coin.id)
                                                ? AppColors.yellow
                                                : AppColors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            onTap: () {
                              Get.delete<CoinDetailsController>();
                              Get.put(
                                CoinDetailsController(
                                  coinChartRepository: CoinChartRepository(
                                    NetworkApiServices(),
                                  ),
                                  coinDetailsRepository: CoinDetailsRepository(
                                    NetworkApiServices(),
                                  ),
                                  favoriteController:
                                      controller.favoriteController,
                                  id: coin.id,
                                  name: coin.name,
                                ),
                              );
                              Get.to(() => CoinDetailsView());
                            },
                          ),
                        );
                      },
                    );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
