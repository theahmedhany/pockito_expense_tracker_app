import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/responsive_helpers/sizer_helper_extension.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../home/business_logic/cubit/expense_cubit.dart';
import '../../../home/data/models/expense_item.dart';
import '../widgets/stats_expense_summary.dart';
import '../../../home/presentation/widgets/expense_tile.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  void deleteExpense(ExpenseItem expense) {
    try {
      context.read<ExpenseCubit>().deleteExpense(expense);
    } catch (e) {
      //TODO: Handle error.
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseCubit, ExpenseState>(
      builder: (context, state) {
        if (state is ExpenseLoaded) {
          final List<ExpenseItem> reversedExpenses =
              state.expenses.reversed.toList();

          return Scaffold(
            backgroundColor: AppColors.kBackgroundColor,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.setMinSize(18),
                  vertical: context.setMinSize(10),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      StatsExpenseSummary(startOfWeek: DateTime.now()),
                      SizedBox(height: context.setHeight(14)),
                      Row(
                        children: [
                          Text(
                            'Week Transactions',
                            style: TextStyle(
                              fontSize: context.setSp(18),
                              fontWeight: FontWeight.bold,
                              color: AppColors.kFontColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.setHeight(8)),
                      buildExpenseList(reversedExpenses),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildExpenseList(List<ExpenseItem> expenses) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return ExpenseTile(
          name: expenses[index].name,
          amount: expenses[index].amount,
          dateTime: expenses[index].dateTime,
          deleteTapped: (BuildContext context) {
            deleteExpense(expenses[index]);
          },
        );
      },
    );
  }
}
