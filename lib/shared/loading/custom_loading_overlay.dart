import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:investor360/shared/style/colors.dart';

class CustomLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const CustomLoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: SpinKitRing(
                lineWidth: 4.8,
                color: NsdlInvestor360Colors.bottomCardHomeColour2,
                size: 50.0,
              ),
            ),
          ),
      ],
    );
  }
}
