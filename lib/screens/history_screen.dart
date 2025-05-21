import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/query_provider.dart';
import '../models/query_model.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History & Dashboard'),
      ),
      body: Consumer<QueryProvider>(
        builder: (context, queryProvider, child) {
          final queries = queryProvider.queries;
          
          // Calculate dashboard statistics
          double totalExpense = 0;
          double totalLent = 0;
          double totalBorrowed = 0;

          for (var query in queries) {
            switch (query.type) {
              case 'Expense':
                totalExpense += query.amount;
                break;
              case 'Lent Money':
                totalLent += query.amount;
                break;
              case 'Borrowed Money':
                totalBorrowed += query.amount;
                break;
            }
          }

          return Column(
            children: [
              // Dashboard Section
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.blue[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildDashboardCard(
                          'Total Expenses',
                          totalExpense,
                          Colors.red,
                          Icons.money_off,
                        ),
                        const SizedBox(width: 16),
                        _buildDashboardCard(
                          'Money Lent',
                          totalLent,
                          Colors.green,
                          Icons.arrow_upward,
                        ),
                        const SizedBox(width: 16),
                        _buildDashboardCard(
                          'Money Borrowed',
                          totalBorrowed,
                          Colors.orange,
                          Icons.arrow_downward,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // History Section
              Expanded(
                child: ListView.builder(
                  itemCount: queries.length,
                  itemBuilder: (context, index) {
                    final query = queries[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getTypeColor(query.type),
                          child: Icon(
                            _getTypeIcon(query.type),
                            color: Colors.white,
                          ),
                        ),
                        title: Text(query.title),
                        subtitle: Text(
                          DateFormat('MMM dd, yyyy').format(query.createdAt),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '₹${query.amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getTypeColor(query.type),
                              ),
                            ),
                            Text(
                              query.type,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDashboardCard(
    String title,
    double amount,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '₹${amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Expense':
        return Colors.red;
      case 'Lent Money':
        return Colors.green;
      case 'Borrowed Money':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Expense':
        return Icons.money_off;
      case 'Lent Money':
        return Icons.arrow_upward;
      case 'Borrowed Money':
        return Icons.arrow_downward;
      default:
        return Icons.money;
    }
  }
} 