import 'package:flutter/material.dart';
import '../models/query_model.dart';
import '../services/hive_service.dart';

class QueryProvider with ChangeNotifier {
  List<QueryModel> _queries = [];

  List<QueryModel> get queries => _queries;

  QueryProvider() {
    _loadQueries();
  }

  Future<void> _loadQueries() async {
    final box = HiveService.queryBox;
    _queries = box.values.toList(); // Load all values from Hive
    notifyListeners();
  }

  Future<void> addQuery(QueryModel query) async {
    final box = HiveService.queryBox;
    await box.add(query); // Add to Hive
    _queries.add(query);
    notifyListeners();
  }

    Future<void> updateQuery(QueryModel oldQuery, QueryModel newQuery) async {
    final box = HiveService.queryBox;
    final index = _queries.indexOf(oldQuery);
    if (index != -1) {
      final key = oldQuery.key; // Access the Hive key from the HiveObject
      await box.put(key, newQuery);
      _queries[index] = newQuery;
      notifyListeners();
    }
  }

  Future<void> deleteQuery(QueryModel queryToDelete) async {
    final box = HiveService.queryBox;
    final index = _queries.indexOf(queryToDelete);
    if (index != -1) {
      await queryToDelete.delete(); // Use the delete() method from HiveObject
      _queries.removeAt(index);
      notifyListeners();
    }
  }
}