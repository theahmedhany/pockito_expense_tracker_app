import 'package:hive/hive.dart';
import '../../features/home/data/models/expense_item.dart';

class HiveDatabase {
  final myBox = Hive.box("EXPENSE_DATABASE");

  void saveData(List<ExpenseItem> allExpense) {
    List<List<dynamic>> allExpensesFormatted = [];

    for (var expense in allExpense) {
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];
      allExpensesFormatted.add(expenseFormatted);
    }

    myBox.put("ALL_EXPENSES", allExpensesFormatted);
  }

  List<ExpenseItem> readData() {
    List savedExpenses = myBox.get("ALL_EXPENSES") ?? [];

    List<ExpenseItem> allExpenses = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      ExpenseItem expense = ExpenseItem(
        name: name,
        amount: amount,
        dateTime: dateTime,
      );

      allExpenses.add(expense);
    }

    return allExpenses;
  }
}
