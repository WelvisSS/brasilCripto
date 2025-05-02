import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/favorite_coin.dart';

class FavoriteRepository {
  static const String _favoritesKey = 'favorites';

  Future<List<FavoriteCoin>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_favoritesKey);
    if (jsonString == null) return [];

    final List decoded = jsonDecode(jsonString);
    return decoded.map((item) => FavoriteCoin.fromJson(item)).toList();
  }

  Future<void> addFavorite(FavoriteCoin coin) async {
    final favorites = await getFavorites();
    if (!favorites.any((c) => c.id == coin.id)) {
      favorites.add(coin);
      await _saveFavorites(favorites);
    }
  }

  Future<void> removeFavorite(String id) async {
    final favorites = await getFavorites();
    favorites.removeWhere((coin) => coin.id == id);
    await _saveFavorites(favorites);
  }

  Future<bool> isFavorite(String id) async {
    final favorites = await getFavorites();
    return favorites.any((coin) => coin.id == id);
  }

  Future<void> _saveFavorites(List<FavoriteCoin> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = favorites.map((c) => c.toJson()).toList();
    prefs.setString(_favoritesKey, jsonEncode(jsonList));
  }

  Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_favoritesKey);
  }
}
