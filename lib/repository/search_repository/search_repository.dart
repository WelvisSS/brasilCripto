import '../../data/network/network_api_services.dart';
import '../../models/coin_search_result_model.dart';
import '../../res/app_url/app_url.dart';

class SearchRepository {
  final NetworkApiServices _apiService;
  SearchRepository(this._apiService);

  Future<CoinSearchResultModel?> fetchCoins(String query) async {
    final response = await _apiService.getGetApiResponse(
      AppUrl.coinSearch(query),
    );

    return CoinSearchResultModel.fromJson(response);
  }
}
