import '../../data/network/network_api_services.dart';
import '../../models/coin_details_model.dart';
import '../../res/app_url/app_url.dart';

class CoinDetailsRepository {
  final NetworkApiServices _apiService;
  CoinDetailsRepository(this._apiService);

  Future<CoinDetailsModel> fetchCoinDetails(String coinId) async {
    final response = await _apiService.getGetApiResponse(
      AppUrl.coinDetails(coinId),
    );

    return CoinDetailsModel.fromJson(response);
  }
}
