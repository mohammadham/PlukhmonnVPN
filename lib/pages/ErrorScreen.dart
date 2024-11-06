import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final Object? error;
  final VoidCallback? onRetry;

  const ErrorScreen({Key? key, required this.error, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: Colors.red, // Or your error color
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red, // Or your error color
                ),
                const SizedBox(height: 16),
                Text(
                  'Oops, something went wrong!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(), // Display the error message
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:onRetry,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}