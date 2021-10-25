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

  final VoidCallback onPressed;
  final String text;
  final double width;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width / 2,
      child: Padding(
        padding: const EdgeInsets.all(kHorizontalPadding),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const SizedBox(
                    height: 16.0,
                    child: CircularProgressIndicator(color: Colors.white))
              else
                Text(text)
            ],
          ),
          style: ElevatedButton.styleFrom(elevation: 0),
        ),
      ),
    );
  }
}
