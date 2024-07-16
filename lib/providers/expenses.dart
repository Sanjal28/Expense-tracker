import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/expense.dart';

class Expenses with ChangeNotifier {
  final List<Expense> _items = [];

  List<Expense> get expenses {
    return [..._items];
  }

  List<Expense> get recentExpenses {
    return _items.where((exp) {
      return exp.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  Expenses() {
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final storedExpenses = prefs.getString('expenses') ?? '[]';
    final decodedExpenses = json.decode(storedExpenses) as List<dynamic>;
    _items.addAll(decodedExpenses.map((item) => Expense(
      id: item['id'],
      title: item['title'],
      amount: item['amount'],
      date: DateTime.parse(item['date']),
      category: Category.values.firstWhere((e) => e.toString() == item['category']),
    )));
    notifyListeners();
  }

  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedExpenses = json.encode(_items.map((exp) => {
      'id': exp.id,
      'title': exp.title,
      'amount': exp.amount,
      'date': exp.date.toIso8601String(),
      'category': exp.category.toString(),
    }).toList());
    prefs.setString('expenses', encodedExpenses);
  }

  void addExpense(Expense expense) {
    _items.add(expense);
    _saveExpenses();
    notifyListeners();
  }

  void deleteExpense(String id) {
    _items.removeWhere((exp) => exp.id == id);
    _saveExpenses();
    notifyListeners();
  }
}
