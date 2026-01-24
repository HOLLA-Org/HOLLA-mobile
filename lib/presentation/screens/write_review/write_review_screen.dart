import 'package:flutter/material.dart';

class WriteReviewScreen extends StatelessWidget {
  const WriteReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Write a Review')),
      body: const Center(child: Text('Write Review Screen Content Here')),
    );
  }
}
