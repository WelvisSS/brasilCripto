import 'package:get/get.dart';
import 'package:mrx_charts/mrx_charts.dart';

import '../../../data/response/status.dart';
import '../../../models/coin_details_model.dart';
import '../../../models/market_chart_model.dart';
import '../../../repository/coin_chart_repository/coin_chart_repository.dart';
import '../../../repository/coin_details_repository/coin_details_repository.dart';
import '../../../utils/error_handler.dart';
import '../favorite/favorite_view_model.dart';

class CoinDetailsController extends GetxController {
  final CoinDetailsRepository coinDetailsRepository;
  final CoinChartRepository coinChartRepository;
  final FavoriteController favoriteController;
  final String id;
  final String name;

  CoinDetailsController({
    required this.coinDetailsRepository,
    required this.coinChartRepository,
    required this.favoriteController,
    required this.id,
    required this.name,
  });

  final rxRequestStatus = Status.LOADING.obs;
  final coinDetails = Rx<CoinDetailsModel?>(null);
  final chart = Rx<MarketChartModel?>(null);
  final chartData = RxList<ChartLineDataItem>([]);
  final error = RxString('');
  final coinId = RxString('');
  final coinName = RxString('');
  final isFavorite = RxBool(false);

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  void setCoinDetails(CoinDetailsModel? value) => coinDetails.value = value;
  void setChart(MarketChartModel? value) => chart.value = value;
  void setError(String value) => error.value = value;
  void setCoinId(String value) => coinId.value = value;

  @override
  void onInit() {
    super.onInit();
    coinId.value = id;
    coinName.value = name;
    fetchCoinDetails(coinId.value);
    fetchCoinChart(coinId.value);
    isFavorite.value = favoriteController.isFavorite(coinId.value);
  }

  void fetchCoinDetails(String coinId) {
    coinDetailsRepository
        .fetchCoinDetails(coinId)
        .then((value) {
          setCoinId(coinId);
          setRxRequestStatus(Status.COMPLETED);
          setCoinDetails(value);
        })
        .onError((error, stackTrace) {
          setCoinId(coinId);
          setError(mapErrorToMessage(error as Object));
          setRxRequestStatus(Status.ERROR);
        });
  }

  void updateChartData(value) {
    chartData.value =
        value.prices.asMap().entries.map<ChartLineDataItem>((entry) {
          final index = entry.key.toDouble();
          final price = entry.value[1].toDouble();
          return ChartLineDataItem(x: index, value: price);
        }).toList();
  }

  void fetchCoinChart(String coinId) {
    coinChartRepository
        .fetchCoinChart(coinId)
        .then((value) {
          setRxRequestStatus(Status.COMPLETED);
          setChart(value);
          updateChartData(chart.value);
        })
        .onError((error, stackTrace) {
          setError(mapErrorToMessage(error as Object));
          setRxRequestStatus(Status.ERROR);
        });
  }

  void refreshApi() {
    setRxRequestStatus(Status.LOADING);

    coinDetailsRepository
        .fetchCoinDetails(coinId.value)
        .then((value) {
          setRxRequestStatus(Status.COMPLETED);
          setCoinDetails(value);
        })
        .onError((error, stackTrace) {
          setError(mapErrorToMessage(error as Object));
          setRxRequestStatus(Status.ERROR);
        });

    coinChartRepository
        .fetchCoinChart(coinId.value)
        .then((value) {
          setRxRequestStatus(Status.COMPLETED);
          setChart(value);
          updateChartData(chart.value);
        })
        .onError((error, stackTrace) {
          setError(mapErrorToMessage(error as Object));
          setRxRequestStatus(Status.ERROR);
        });
  }
}
