import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../models/favorite_coin.dart';
import '../../../repository/favorite_repository/favorite_repository.dart';

class FavoriteController extends GetxController {
  final FavoriteRepository favoriteRepository;

  FavoriteController({required this.favoriteRepository});

  final favorites = <FavoriteCoin>[].obs;
  final filteredFavorites = <FavoriteCoin>[].obs;
  final searchController = TextEditingController();

  setFavorites(List<FavoriteCoin> coins) => favorites.value = coins;
  setFilteredFavorites(List<FavoriteCoin> coins) =>
      filteredFavorites.value = coins;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  void filterFavorites(String query) {
    if (query.isEmpty) {
      filteredFavorites.value = favorites;
    } else {
      setFilteredFavorites(
        favorites
            .where(
              (coin) => coin.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      );
    }
  }

  Future<void> loadFavorites() async {
    final data = await favoriteRepository.getFavorites();
    setFavorites(data);
    setFilteredFavorites(data);
  }

  Future<void> addFavorite(FavoriteCoin coin) async {
    if (!isFavorite(coin.id)) {
      await favoriteRepository.addFavorite(coin);
      loadFavorites();
    }
  }

  Future<void> removeFavorite(String id) async {
    await favoriteRepository.removeFavorite(id);
    loadFavorites();
  }

  bool isFavorite(String id) {
    return favorites.any((coin) => coin.id == id);
  }
}
