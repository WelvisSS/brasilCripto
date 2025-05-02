import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/network/network_api_services.dart';
import '../data/response/status.dart';
import '../repository/coin_chart_repository/coin_chart_repository.dart';
import '../repository/coin_details_repository/coin_details_repository.dart';
import '../res/colors/colors.dart';
import '../shared/widgets/search_input.dart';
import '../shared/widgets/sparkline_chart.dart';
import '../utils/format_abbreviated_currency.dart';
import '../utils/format_percentage_change.dart';
import '../view_models/controllers/coin_details/coin_details_view_model.dart';
import '../view_models/controllers/favorite/favorite_view_model.dart';
import '../view_models/controllers/search/search_view_model.dart' as search_vm;
import 'coin_details_view.dart';
import 'error_view.dart';

class SearchView extends GetView<search_vm.SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: 4,
          ),
          child: Column(
            children: [
              SearchInput(
                searchController: controller.searchController,
                onPressed: () => controller.searchApi(""),
                onChanged: (value) => controller.searchApi(value),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (controller.rxRequestStatus.value == Status.LOADING) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  } else if (controller.rxRequestStatus.value == Status.ERROR) {
                    return ErrorView(
                      message: controller.error.value,
                      onRetry: () => controller.refreshApi(),
                    );
                  } else if (controller.coinSearchResult.value == null ||
                      controller.coinSearchResult.value!.coins.isEmpty) {
                    return const Center(
                      child: Text(
                        "Nenhuma criptomoeda encontrada",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.secondary,
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: controller.cryptoSummary.length,
                      itemBuilder: (context, index) {
                        final coin = controller.cryptoSummary[index];
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
                                      onTap:
                                          () => controller.addFavorite(
                                            coin.id,
                                            coin.name,
                                            coin.image,
                                            coin.symbol,
                                          ),
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
                                      Get.find<FavoriteController>(),
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
      ),
    );
  }
}
