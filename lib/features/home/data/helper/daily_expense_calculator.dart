import 'date_time_helper.dart';
import '../models/expense_item.dart';

class DailyExpenseCalculator {
  static double calculateDayTotal(
      DateTime targetDate, List<ExpenseItem> expenses) {
    String dateString = convertDateTimeToString(targetDate);
    Map<String, double> dailySummary = _calculateDailyExpenseSummary(expenses);
    return dailySummary[dateString] ?? 0.0;
  }

  static Map<String, double> _calculateDailyExpenseSummary(
      List<ExpenseItem> expenses) {
    Map<String, double> dailyExpenseSummary = {};

    for (var expense in expenses) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)) {
        dailyExpenseSummary[date] = dailyExpenseSummary[date]! + amount;
      } else {
        dailyExpenseSummary[date] = amount;
      }
    }

    return dailyExpenseSummary;
  }
}
