import '../../data/network/network_api_services.dart';
import '../../models/market_chart_model.dart';
import '../../res/app_url/app_url.dart';

class CoinChartRepository {
  final NetworkApiServices _apiService;
  CoinChartRepository(this._apiService);

  Future<MarketChartModel> fetchCoinChart(String coinId) async {
    final response = await _apiService.getGetApiResponse(
      AppUrl.coinMarketChart(coinId, days: 30),
    );

    return MarketChartModel.fromJson(response);
  }
}
