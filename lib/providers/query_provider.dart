import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/query_model.dart';
import '../services/hive_service.dart';

class QueryProvider with ChangeNotifier {
  final Box<QueryModel> _box = HiveService.queryBox;

  List<QueryModel> get queries => _box.values.where((query) => !query.isDeleted).toList();
  
  List<QueryModel> get deletedQueries => _box.values.where((query) => query.isDeleted).toList();

  QueryProvider() {
    _loadQueries();
  }

  Future<void> _loadQueries() async {
    await _box.values.toList(); // Load all values from Hive
    notifyListeners();
  }

  void addQuery(QueryModel query) {
    _box.add(query);
    notifyListeners();
  }

  void updateQuery(QueryModel oldQuery, QueryModel newQuery) {
    final index = _box.values.toList().indexOf(oldQuery);
    if (index != -1) {
      _box.putAt(index, newQuery);
      notifyListeners();
    }
  }

  void deleteQuery(QueryModel query) {
    final index = _box.values.toList().indexOf(query);
    if (index != -1) {
      query.isDeleted = true;
      _box.putAt(index, query);
      notifyListeners();
    }
  }

  void restoreQuery(QueryModel query) {
    final index = _box.values.toList().indexOf(query);
    if (index != -1) {
      query.isDeleted = false;
      _box.putAt(index, query);
      notifyListeners();
    }
  }

  void permanentlyDeleteQuery(QueryModel query) {
    query.delete();
    notifyListeners();
  }
}