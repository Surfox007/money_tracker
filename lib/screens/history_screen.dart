import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/query_provider.dart';
import '../models/query_model.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deleted Transactions'),
      ),
      body: Consumer<QueryProvider>(
        builder: (context, queryProvider, child) {
          final deletedQueries = queryProvider.deletedQueries;

          if (deletedQueries.isEmpty) {
            return const Center(
              child: Text(
                'No deleted transactions',
                style: TextStyle(
                  color: AppTheme.darkTextSecondary,
                  fontSize: 16,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: deletedQueries.length,
            itemBuilder: (context, index) {
              final query = deletedQueries[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: _getTypeColor(query.type),
                    child: Icon(
                      _getTypeIcon(query.type),
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    query.title,
                    style: const TextStyle(
                      color: AppTheme.darkTextPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        query.type,
                        style: const TextStyle(
                          color: AppTheme.darkTextSecondary,
                        ),
                      ),
                      Text(
                        'Deleted on ${DateFormat('MMM dd, yyyy').format(query.createdAt)}',
                        style: const TextStyle(
                          color: AppTheme.darkTextSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '₹${query.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getTypeColor(query.type),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.restore, color: AppTheme.primary),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: AppTheme.darkCard,
                              title: const Text(
                                'Restore Transaction',
                                style: TextStyle(color: AppTheme.darkTextPrimary),
                              ),
                              content: const Text(
                                'Are you sure you want to restore this transaction?',
                                style: TextStyle(color: AppTheme.darkTextSecondary),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    queryProvider.restoreQuery(query);
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Restore',
                                    style: TextStyle(color: AppTheme.primary),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_forever, color: AppTheme.error),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: AppTheme.darkCard,
                              title: const Text(
                                'Permanently Delete',
                                style: TextStyle(color: AppTheme.darkTextPrimary),
                              ),
                              content: const Text(
                                'Are you sure you want to permanently delete this transaction? This action cannot be undone.',
                                style: TextStyle(color: AppTheme.darkTextSecondary),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    queryProvider.permanentlyDeleteQuery(query);
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Delete Forever',
                                    style: TextStyle(color: AppTheme.error),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Expense':
        return AppTheme.expenseColor;
      case 'Lent Money':
        return AppTheme.lentColor;
      case 'Borrowed Money':
        return AppTheme.borrowedColor;
      default:
        return AppTheme.primary;
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