import '../models/expense_item.dart';
import 'date_time_helper.dart';

Map<String, double> calculateDailyExpenseSummary(List<ExpenseItem> expenses) {
  final Map<String, double> dailyExpenseSummary = {};

  for (var expense in expenses) {
    final String date = convertDateTimeToString(expense.dateTime);
    final double amount = double.parse(expense.amount);

    dailyExpenseSummary[date] = (dailyExpenseSummary[date] ?? 0) + amount;
  }

  return dailyExpenseSummary;
}

String calculateWeekTotal(List<ExpenseItem> expenses) {
  final double total =
      expenses.fold(0.0, (sum, item) => sum + double.parse(item.amount));
  return total.toStringAsFixed(2);
}

double calculateMaxExpense(Map<String, double> dailySummary,
    {double defaultMax = 100, double buffer = 10}) {
  if (dailySummary.isEmpty) return defaultMax;
  final double maxExpense = dailySummary.values.reduce((a, b) => a > b ? a : b);
  return maxExpense + (maxExpense * buffer / 100);
}
