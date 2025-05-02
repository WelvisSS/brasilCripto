import 'package:brasil_cripto/models/coin_market_data_model.dart';
import 'package:get/get.dart';

import '../../../data/response/status.dart';
import '../../../models/favorite_coin.dart';
import '../../../repository/home_repository/hone_repository.dart';
import '../../../utils/error_handler.dart';
import '../favorite/favorite_view_model.dart';

class HomeController extends GetxController {
  final HomeRepository homeRepository;
  final FavoriteController favoriteController;
  HomeController({
    required this.homeRepository,
    required this.favoriteController,
  });

  final rxRequestStatus = Status.LOADING.obs;
  final coinList = RxList<CoinMarketDataModel>();
  final error = RxString('');
  final selectedIndex = RxInt(0);

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  void setCoinList(List<CoinMarketDataModel> value) => coinList.value = value;
  void setError(String value) => error.value = value;

  void addFavorite(String coinId, String name, String image, String symbol) {
    final favoriteCoin = FavoriteCoin(
      id: coinId,
      name: name,
      image: image,
      symbol: symbol,
    );
    favoriteController.addFavorite(favoriteCoin);
  }

  @override
  void onInit() {
    super.onInit();
    coinMarketApi();
  }

  void coinMarketApi() {
    homeRepository
        .fetchMarketCoins()
        .then((value) {
          setRxRequestStatus(Status.COMPLETED);
          setCoinList(value);
        })
        .onError((error, stackTrace) {
          setError(mapErrorToMessage(error as Object));
          setRxRequestStatus(Status.ERROR);
        });
  }

  void refreshApi() {
    setRxRequestStatus(Status.LOADING);

    homeRepository
        .fetchMarketCoins()
        .then((value) {
          setRxRequestStatus(Status.COMPLETED);
          setCoinList(value);
        })
        .onError((error, stackTrace) {
          setError(mapErrorToMessage(error as Object));
          setRxRequestStatus(Status.ERROR);
        });
  }
}
