import 'dart:async';

import 'package:brasil_cripto/res/colors/colors.dart';
import 'package:flutter/material.dart';

class CircularCountdownTimer extends StatefulWidget {
  final int seconds;
  final VoidCallback onFinish;

  const CircularCountdownTimer({
    super.key,
    this.seconds = 10,
    required this.onFinish,
  });

  @override
  State<CircularCountdownTimer> createState() => _CircularCountdownTimerState();
}

class _CircularCountdownTimerState extends State<CircularCountdownTimer> {
  Timer? _timer;
  late DateTime _startTime;
  double _progress = 1.0;
  int _displaySeconds = 0;

  @override
  void initState() {
    super.initState();
    _startCycle();
  }

  void _startCycle() {
    _startTime = DateTime.now();
    _displaySeconds = widget.seconds;
    _progress = 1.0;

    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      final elapsed = DateTime.now().difference(_startTime).inMilliseconds;
      final totalMs = widget.seconds * 1000;
      final remainingMs = totalMs - elapsed;

      if (remainingMs <= 0) {
        if (mounted) {
          widget.onFinish();
          _startCycle();
        } else {
          _timer?.cancel();
        }
        return;
      }

      if (mounted) {
        setState(() {
          _progress = remainingMs / totalMs;
          _displaySeconds = (remainingMs / 1000).ceil();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: _progress,
            strokeWidth: 2,
            backgroundColor: AppColors.black,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.secondary,
            ),
          ),
          Text(
            '$_displaySeconds',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
