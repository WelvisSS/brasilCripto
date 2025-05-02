import '../../data/network/network_api_services.dart';
import '../../models/coin_market_data_model.dart';
import '../../res/app_url/app_url.dart';

class HomeRepository {
  final NetworkApiServices _apiService;
  HomeRepository(this._apiService);

  Future<List<CoinMarketDataModel>> fetchMarketCoins() async {
    final response = await _apiService.getGetApiResponse(AppUrl.coinMarkets());

    return List<CoinMarketDataModel>.from(
      (response as List).map(
        (json) => CoinMarketDataModel.fromJson(json as Map<String, dynamic>),
      ),
    );
  }
}
