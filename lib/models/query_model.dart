import 'package:hive/hive.dart';

part 'query_model.g.dart'; // Generated adapter

@HiveType(typeId: 0)
class QueryModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  double amount;

  @HiveField(2)
  String type; // "Expense" or "Loan"

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  bool isDeleted;

  QueryModel({
    required this.title,
    required this.amount,
    required this.type,
    required this.createdAt,
    this.isDeleted = false,
  });
}
