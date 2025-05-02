import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/network/network_api_services.dart';
import '../repository/coin_chart_repository/coin_chart_repository.dart';
import '../repository/coin_details_repository/coin_details_repository.dart';
import '../res/colors/colors.dart';
import '../shared/widgets/confirm_dialog.dart';
import '../shared/widgets/search_input.dart';
import '../view_models/controllers/coin_details/coin_details_view_model.dart';
import '../view_models/controllers/favorite/favorite_view_model.dart';
import 'coin_details_view.dart';

class FavoriteView extends GetView<FavoriteController> {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SearchInput(
                searchController: controller.searchController,
                onPressed: () {
                  controller.searchController.clear();
                  controller.filterFavorites('');
                },
                onChanged: (value) => controller.filterFavorites(value),
              ),
              const SizedBox(height: 16),
              Expanded(
                child:
                    controller.filteredFavorites.isEmpty
                        ? const Center(
                          child: Text(
                            "Nenhuma criptomoeda encontrada.",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.secondary,
                            ),
                          ),
                        )
                        : ListView.builder(
                          itemCount: controller.filteredFavorites.length,
                          itemBuilder: (context, index) {
                            final coin = controller.filteredFavorites[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              color: AppColors.black,

                              child: ListTile(
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: coin.image,
                                      width: 24,
                                      height: 24,
                                      placeholder:
                                          (context, url) =>
                                              CircularProgressIndicator(
                                                strokeWidth: 1,
                                                color: AppColors.secondary,
                                              ),
                                      errorWidget:
                                          (context, url, error) =>
                                              Icon(Icons.error),
                                    ),
                                  ],
                                ),
                                title: Text(
                                  coin.symbol,
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  coin.name,
                                  style: const TextStyle(
                                    color: AppColors.secondary,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: AppColors.secondary,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => ConfirmDialog(
                                            title: 'Remover da lista',
                                            message:
                                                'Tem certeza que deseja remover esta criptomoeda dos favoritos?',
                                            onConfirm: () {
                                              controller.removeFavorite(
                                                controller.favorites[index].id,
                                              );
                                              controller.favorites.removeAt(
                                                index,
                                              );
                                            },
                                          ),
                                    );
                                  },
                                ),
                                onTap: () {
                                  Get.delete<CoinDetailsController>();
                                  Get.put(
                                    CoinDetailsController(
                                      coinChartRepository: CoinChartRepository(
                                        NetworkApiServices(),
                                      ),
                                      coinDetailsRepository:
                                          CoinDetailsRepository(
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
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
