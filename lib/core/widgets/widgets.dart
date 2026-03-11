import 'package:flutter/material.dart';
import '../../../features/dashboard/data/models/dashboard_model.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const CustomErrorWidget({Key? key, required this.message, required this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}


