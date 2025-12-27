import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieLoader extends StatelessWidget {
  final double size;

  const LottieLoader({super.key, this.size = 150});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/animations/loading.json',
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}
