import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/query_provider.dart';
import '../models/query_model.dart';
import '../theme/app_theme.dart';
import 'add_query_screen.dart';
import 'edit_query_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Tracker'),
      ),
      body: _selectedIndex == 0 ? _buildHomeContent() : const HistoryScreen(),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddQueryScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return Consumer<QueryProvider>(
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
              decoration: BoxDecoration(
                color: AppTheme.darkSurface,
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.darkDivider,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildDashboardCard(
                        'Total Expenses',
                        totalExpense,
                        AppTheme.expenseColor,
                        Icons.money_off,
                      ),
                      const SizedBox(width: 16),
                      _buildDashboardCard(
                        'Money Lent',
                        totalLent,
                        AppTheme.lentColor,
                        Icons.arrow_upward,
                      ),
                      const SizedBox(width: 16),
                      _buildDashboardCard(
                        'Money Borrowed',
                        totalBorrowed,
                        AppTheme.borrowedColor,
                        Icons.arrow_downward,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: AppTheme.inputDecoration(
                  hintText: 'Search transactions...',
                  prefixIcon: Icons.search,
                ),
                style: const TextStyle(color: AppTheme.darkTextPrimary),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

            // Transaction List
            Expanded(
              child: Consumer<QueryProvider>(
                builder: (context, queryProvider, child) {
                  final queries = queryProvider.queries;
                  final filteredQueries = queries.where((query) {
                    final titleLower = query.title.toLowerCase();
                    final typeLower = query.type.toLowerCase();
                    final searchLower = _searchQuery.toLowerCase();
                    
                    return titleLower.contains(searchLower) || 
                           typeLower.contains(searchLower);
                  }).toList();

                  if (filteredQueries.isEmpty) {
                    return Center(
                      child: Text(
                        _searchQuery.isEmpty 
                            ? 'No transactions yet'
                            : 'No matching transactions found',
                        style: const TextStyle(
                          color: AppTheme.darkTextSecondary,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredQueries.length,
                    itemBuilder: (context, index) {
                      final query = filteredQueries[index];
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
                          subtitle: Text(
                            query.type,
                            style: const TextStyle(
                              color: AppTheme.darkTextSecondary,
                            ),
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
                                icon: const Icon(Icons.edit, color: AppTheme.primary),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditQueryScreen(
                                        query: query,
                                        index: queries.indexOf(query),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: AppTheme.error),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: AppTheme.darkCard,
                                      title: const Text(
                                        'Delete Transaction',
                                        style: TextStyle(color: AppTheme.darkTextPrimary),
                                      ),
                                      content: const Text(
                                        'Are you sure you want to delete this transaction?',
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
                                            queryProvider.deleteQuery(query);
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Delete',
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
            ),
          ],
        );
      },
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
        decoration: AppTheme.dashboardCardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.darkTextSecondary,
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
