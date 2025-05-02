import '../../data/network/network_api_services.dart';
import '../../models/crypto_summary_model.dart';
import '../../res/app_url/app_url.dart';

class CoinMarketRepository {
  final NetworkApiServices _apiService;
  CoinMarketRepository(this._apiService);

  Future<List<CryptoSummaryModel>> fetchCoinMarket(List<String> ids) async {
    final response = await _apiService.getGetApiResponse(
      AppUrl.specificCoinsMarket(ids: ids),
    );

    return List<CryptoSummaryModel>.from(
      (response as List).map(
        (json) => CryptoSummaryModel.fromJson(json as Map<String, dynamic>),
      ),
    );
    ;
  }
}
