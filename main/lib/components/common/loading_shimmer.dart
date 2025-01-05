import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  final Widget content;

  const LoadingShimmer({
    super.key,
    required this.content
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Get.isDarkMode
        ? const Color(0xff8C8C8C)
        : const Color.fromARGB(255, 210, 210, 210),
      highlightColor: Get.isDarkMode
        ? const Color.fromARGB(255, 176, 176, 176)
        : Colors.grey.shade300,
      child: content
    );
  }
}