import 'package:brasil_cripto/repository/coin_details_repository/crypto_summary_repository.dart';
import 'package:get/get.dart';

import '../../data/network/network_api_services.dart';
import '../../repository/favorite_repository/favorite_repository.dart';
import '../../repository/home_repository/hone_repository.dart';
import '../../repository/search_repository/search_repository.dart';
import '../../view/main_view.dart';
import '../../view_models/controllers/favorite/favorite_view_model.dart';
import '../../view_models/controllers/home/home_view_model.dart';
import '../../view_models/controllers/search/search_view_model.dart';
import 'routes_name.dart';

class AppRoutes {
  static appRoutes() => [
    GetPage(
      name: RouteName.main,
      page: () => MainScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<FavoriteController>(
          () => FavoriteController(favoriteRepository: FavoriteRepository()),
        );
        Get.lazyPut<HomeController>(
          () => HomeController(
            homeRepository: HomeRepository(NetworkApiServices()),
            favoriteController: Get.find<FavoriteController>(),
          ),
        );
        Get.lazyPut<SearchController>(
          () => SearchController(
            searchRepository: SearchRepository(NetworkApiServices()),
            coinMarketRepository: CoinMarketRepository(NetworkApiServices()),
            favoriteController: Get.find<FavoriteController>(),
          ),
        );
      }),
    ),
  ];
}
