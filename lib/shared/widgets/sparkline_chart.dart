import 'package:flutter/material.dart';
import 'package:mrx_charts/mrx_charts.dart';

import '../../res/colors/colors.dart';

class SparklineChart extends StatelessWidget {
  final List<double> prices;
  const SparklineChart({super.key, required this.prices});

  @override
  Widget build(BuildContext context) {
    final items =
        prices.asMap().entries.map<ChartLineDataItem>((entry) {
          final index = entry.key.toDouble();
          final price = entry.value.toDouble();
          return ChartLineDataItem(x: index, value: price);
        }).toList();

    final minY = prices.reduce((a, b) => a < b ? a : b) * 0.98;
    final maxY = prices.reduce((a, b) => a > b ? a : b) * 1.02;

    return SizedBox(
      width: 40,
      height: 40,
      child: Chart(
        layers: [
          ChartAxisLayer(
            labelX: (_) => '',
            labelY: (_) => '',
            settings: ChartAxisSettings(
              x: ChartAxisSettingsAxis(
                frequency: 1,
                min: 0,
                max: items.length.toDouble(),
                textStyle: const TextStyle(
                  fontSize: 8,
                  color: AppColors.transparent,
                ),
              ),
              y: ChartAxisSettingsAxis(
                frequency: 1000,
                min: minY,
                max: maxY,
                textStyle: const TextStyle(
                  fontSize: 8,
                  color: AppColors.transparent,
                ),
              ),
            ),
          ),
          ChartLineLayer(
            settings: const ChartLineSettings(
              color: AppColors.secondary,
              thickness: 0.5,
            ),
            items: items,
          ),
        ],
      ),
    );
  }
}
