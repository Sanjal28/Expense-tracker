import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/expenses.dart';
import './screens/expense_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Expenses(),
      child: MaterialApp(
        title: 'Expense Tracker',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          hintColor: Colors.amber,
        ),
        home: ExpenseOverviewScreen(),
      ),
    );
  }
}
