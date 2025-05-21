import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/query_provider.dart';
import '../models/query_model.dart';
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
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search transactions...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
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
                  ),
                );
              }

              return ListView.builder(
                itemCount: filteredQueries.length,
                itemBuilder: (context, index) {
                  final query = filteredQueries[index];
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
                      subtitle: Text(query.type),
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
                            icon: const Icon(Icons.edit),
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
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Transaction'),
                                  content: const Text(
                                      'Are you sure you want to delete this transaction?'),
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
                                      child: const Text('Delete'),
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
