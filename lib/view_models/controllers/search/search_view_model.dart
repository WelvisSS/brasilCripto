import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/response/status.dart';
import '../../../models/coin_search_result_model.dart';
import '../../../models/crypto_summary_model.dart';
import '../../../models/favorite_coin.dart';
import '../../../repository/coin_details_repository/crypto_summary_repository.dart';
import '../../../repository/search_repository/search_repository.dart';
import '../../../utils/error_handler.dart';
import '../favorite/favorite_view_model.dart';

class SearchController extends GetxController {
  final SearchRepository searchRepository;
  final CoinMarketRepository coinMarketRepository;
  final FavoriteController favoriteController;
  SearchController({
    required this.searchRepository,
    required this.coinMarketRepository,
    required this.favoriteController,
  });

  final searchController = TextEditingController();
  final rxRequestStatus = Status.COMPLETED.obs;
  final coinSearchResult = Rx<CoinSearchResultModel?>(null);
  final cryptoSummary = RxList<CryptoSummaryModel>([]);
  final error = RxString('');
  final query = RxString('');
  Timer? _debounce;

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  void setCoinList(CoinSearchResultModel? value) =>
      coinSearchResult.value = value;
  void setCryptoSummary(List<CryptoSummaryModel> value) =>
      cryptoSummary.value = value;
  void setError(String value) => error.value = value;
  void setQuery(String value) => query.value = value;

  void addFavorite(String coinId, String name, String image, String symbol) {
    if (favoriteController.isFavorite(coinId)) {
      favoriteController.removeFavorite(coinId);
    } else {
      final favoriteCoin = FavoriteCoin(
        id: coinId,
        name: name,
        image: image,
        symbol: symbol,
      );
      favoriteController.addFavorite(favoriteCoin);
    }
  }

  void fetchMarketDataForCoins(List<String> ids) async {
    if (ids.isEmpty) {
      setRxRequestStatus(Status.COMPLETED);
      return;
    }

    coinMarketRepository
        .fetchCoinMarket(ids)
        .then((value) {
          setRxRequestStatus(Status.COMPLETED);
          setCryptoSummary(value);
        })
        .onError((error, stackTrace) {
          setError(mapErrorToMessage(error as Object));
          setRxRequestStatus(Status.ERROR);
        });
  }

  void searchApi(String query) {
    setCoinList(null);
    setCryptoSummary([]);
    if (query.isEmpty) {
      _debounce?.cancel();
      searchController.clear();
      setRxRequestStatus(Status.COMPLETED);
      return;
    }
    setRxRequestStatus(Status.LOADING);
    // Cancels the previous debounce if it exists
    _debounce?.cancel();
    // Starts a new debounce
    _debounce = Timer(Duration(seconds: 1), () {
      searchRepository
          .fetchCoins(query)
          .then((value) {
            setQuery(query);
            setCoinList(value);
            fetchMarketDataForCoins(
              value?.coins.map((e) => e.id).toList() ?? [],
            );
            setRxRequestStatus(Status.COMPLETED);
          })
          .onError((error, stackTrace) {
            setQuery(query);
            setError(mapErrorToMessage(error as Object));
            setRxRequestStatus(Status.ERROR);
          });
    });
  }

  void refreshApi() {
    if (query.value.isEmpty) {
      setCoinList(null);
      _debounce?.cancel();
      return;
    }
    setRxRequestStatus(Status.LOADING);
    // Cancels the previous debounce if it exists
    _debounce?.cancel();
    // Starts a new debounce
    _debounce = Timer(Duration(seconds: 1), () {
      searchRepository
          .fetchCoins(query.value)
          .then((value) {
            setCoinList(value);
            fetchMarketDataForCoins(
              value?.coins.map((e) => e.id).toList() ?? [],
            );
            setRxRequestStatus(Status.COMPLETED);
          })
          .onError((error, stackTrace) {
            setError(mapErrorToMessage(error as Object));
            setRxRequestStatus(Status.ERROR);
          });
    });
  }
}
