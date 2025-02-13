import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/responsive_helpers/size_provider.dart';
import '../../../../core/responsive_helpers/sizer_helper_extension.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../home/business_logic/cubit/expense_cubit.dart';
import '../../../home/data/helper/date_time_helper.dart';
import 'bar_graph.dart';
import '../../../home/data/models/expense_item.dart';

class StatsExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;

  const StatsExpenseSummary({super.key, required this.startOfWeek});

  DateTime getStartOfWeek(DateTime date) {
    while (date.weekday != DateTime.sunday) {
      date = date.subtract(const Duration(days: 1));
    }
    return date;
  }

  Map<String, String> getWeekDates(DateTime startOfWeek) {
    return {
      "Sunday": convertDateTimeToString(startOfWeek),
      "Monday":
          convertDateTimeToString(startOfWeek.add(const Duration(days: 1))),
      "Tuesday":
          convertDateTimeToString(startOfWeek.add(const Duration(days: 2))),
      "Wednesday":
          convertDateTimeToString(startOfWeek.add(const Duration(days: 3))),
      "Thursday":
          convertDateTimeToString(startOfWeek.add(const Duration(days: 4))),
      "Friday":
          convertDateTimeToString(startOfWeek.add(const Duration(days: 5))),
      "Saturday":
          convertDateTimeToString(startOfWeek.add(const Duration(days: 6))),
    };
  }

  double calculateMax(Map<String, double> dailySummary,
      {double defaultMax = 100, double buffer = 10}) {
    if (dailySummary.isEmpty) return defaultMax;
    double maxExpense = dailySummary.values.reduce((a, b) => a > b ? a : b);
    return maxExpense + (maxExpense * buffer / 100);
  }

  String calculateWeekTotal(List<ExpenseItem> expenses) {
    double total =
        expenses.fold(0.0, (sum, item) => sum + double.parse(item.amount));
    return total.toStringAsFixed(2);
  }

  Map<String, double> _calculateDailyStatsExpenseSummary(
    List<ExpenseItem> expenses,
  ) {
    Map<String, double> dailyStatsExpenseSummary = {};

    for (var expense in expenses) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyStatsExpenseSummary.containsKey(date)) {
        dailyStatsExpenseSummary[date] =
            dailyStatsExpenseSummary[date]! + amount;
      } else {
        dailyStatsExpenseSummary[date] = amount;
      }
    }

    return dailyStatsExpenseSummary;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseCubit, ExpenseState>(
      builder: (context, state) {
        if (state is ExpenseLoaded) {
          DateTime correctStartOfWeek = getStartOfWeek(startOfWeek);
          Map<String, String> weekDates = getWeekDates(correctStartOfWeek);
          Map<String, double> dailySummary =
              _calculateDailyStatsExpenseSummary(state.expenses);

          return Column(
            children: [
              SizeProvider(
                baseSize: Size(600, 400),
                width: context.setMinSize(600),
                height: context.setMinSize(400),
                child: Builder(builder: (context) {
                  return Container(
                    padding: EdgeInsets.all(
                      context.setMinSize(18),
                    ),
                    height: context.sizeProvider.height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Colors.grey.shade300,
                          offset: const Offset(5, 5),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Weekly Expenses',
                          style: TextStyle(
                            color: AppColors.kFontColor,
                            fontSize: context.setSp(20),
                          ),
                        ),
                        SizedBox(height: context.setHeight(8)),
                        Text(
                          '\£ ${calculateWeekTotal(state.expenses)}',
                          style: TextStyle(
                            color: AppColors.kFontColor,
                            fontWeight: FontWeight.bold,
                            fontSize: context.setSp(26),
                          ),
                        ),
                        SizedBox(height: context.setHeight(12)),
                        Expanded(
                          child: BarGraph(
                            maxY: calculateMax(dailySummary),
                            sunAmount: dailySummary[weekDates["Sunday"]] ?? 0,
                            monAmount: dailySummary[weekDates["Monday"]] ?? 0,
                            tueAmount: dailySummary[weekDates["Tuesday"]] ?? 0,
                            wedAmount:
                                dailySummary[weekDates["Wednesday"]] ?? 0,
                            thurAmount:
                                dailySummary[weekDates["Thursday"]] ?? 0,
                            friAmount: dailySummary[weekDates["Friday"]] ?? 0,
                            satAmount: dailySummary[weekDates["Saturday"]] ?? 0,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
