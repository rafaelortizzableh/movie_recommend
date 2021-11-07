import 'package:flutter/material.dart';
import '../core.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.width = double.infinity,
  }) : super(key: key);
  static const _loadersize16 = 16.0;
  static const _elevation0 = 0.0;
  static const _widthDivisionFactor2 = 2.0;
  final VoidCallback onPressed;
  final String text;
  final double width;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width / _widthDivisionFactor2,
      child: Padding(
        padding: const EdgeInsets.all(kHorizontalPadding),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const SizedBox(
                    height: _loadersize16,
                    width: _loadersize16,
                    child: CircularProgressIndicator(color: Colors.white))
              else
                Text(text)
            ],
          ),
          style: ElevatedButton.styleFrom(elevation: _elevation0),
        ),
      ),
    );
  }
}
