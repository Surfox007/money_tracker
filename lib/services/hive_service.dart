import 'package:hive_flutter/hive_flutter.dart';
import '../models/query_model.dart';

class HiveService {
  static const String boxName = 'queries';

  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(QueryModelAdapter());
    await Hive.openBox<QueryModel>(boxName);
  }

  static Box<QueryModel> get queryBox => Hive.box<QueryModel>(boxName);
}
