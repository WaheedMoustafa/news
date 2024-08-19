import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String error;
  final Function onRetryClick;

  const ErrorView({
    super.key,
    required this.error,
    required this.onRetryClick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(error),
        ElevatedButton(onPressed: () {}, child: Text("Retry"))
      ],
    );
  }
}