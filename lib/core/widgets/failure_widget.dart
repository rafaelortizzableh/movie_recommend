import 'package:flutter/material.dart';

class FailureBody extends StatelessWidget {
  const FailureBody({
    Key? key,
    required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message),
    );
  }
}
