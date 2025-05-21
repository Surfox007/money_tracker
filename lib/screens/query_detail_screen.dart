import 'package:flutter/material.dart';
import '../models/query_model.dart';

class QueryDetailScreen extends StatelessWidget {
  final QueryModel query;
  final int index;

  const QueryDetailScreen({
    super.key,
    required this.query,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Query Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${query.title}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Amount: ৳${query.amount}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Type: ${query.type}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Created At: ${query.createdAt.toLocal()}',
                style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
