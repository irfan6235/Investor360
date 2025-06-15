import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CommonShimmerWidget extends StatelessWidget {
  final Widget child;

  CommonShimmerWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      enabled: true,
      child: Container(
        child: child,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      period: const Duration(milliseconds: 750),
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.white,
    );
  }
}
