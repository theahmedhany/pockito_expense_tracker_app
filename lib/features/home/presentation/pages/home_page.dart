import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/responsive_helpers/size_provider.dart';
import '../../../../core/responsive_helpers/sizer_helper_extension.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../stats/presentation/pages/stats_page.dart';
import '../../business_logic/cubit/expense_cubit.dart';
import '../../data/helper/daily_expense_calculator.dart';
import '../../data/models/expense_item.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/expense_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  int index = 0;
  Color selectedItem = AppColors.kPurpleColor;
  Color unselectedItem = Colors.grey;

  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => SizeProvider(
        baseSize: Size(300, 300),
        width: context.setMinSize(300),
        height: context.setMinSize(300),
        child: Builder(builder: (context) {
          return AlertDialog(
            backgroundColor: AppColors.kBackgroundColor.withValues(alpha: 0.9),
            title: Text(
              'Add New Expense',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.setSp(22),
                color: AppColors.kFontColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: context.setHeight(20)),
                  CustomTextField(
                    controller: newExpenseNameController,
                    hintText: 'Expense Name',
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: context.setHeight(20)),
                  CustomTextField(
                    controller: newExpenseAmountController,
                    hintText: 'Expense Amount',
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: context.setHeight(50)),
                  CupertinoButton(
                    onPressed: onSave,
                    padding: EdgeInsets.zero,
                    child: Container(
                      height: context.setHeight(54),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.kOrangeColor,
                            AppColors.kPurpleColor,
                            AppColors.kBlueColor,
                          ],
                          transform: const GradientRotation(pi / 4),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: context.setSp(20),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.setHeight(20)),
                  CupertinoButton(
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    child: Container(
                      height: context.setHeight(54),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.kOrangeColor,
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: context.setSp(20),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void onSave() {
    if (newExpenseNameController.text.isNotEmpty &&
        newExpenseAmountController.text.isNotEmpty) {
      ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text,
        amount: newExpenseAmountController.text,
        dateTime: DateTime.now(),
      );

      context.read<ExpenseCubit>().addExpense(newExpense);
    }

    Navigator.pop(context);
    clear();
  }

  void clear() {
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
  }

  void deleteExpense(ExpenseItem expense) {
    context.read<ExpenseCubit>().deleteExpense(expense);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseCubit, ExpenseState>(
      builder: (context, state) {
        if (state is ExpenseLoaded) {
          double todayTotal = DailyExpenseCalculator.calculateDayTotal(
              DateTime.now(), state.expenses);
          return Scaffold(
            backgroundColor: AppColors.kBackgroundColor,
            bottomNavigationBar: _buildBottomNavigationBar(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: _buildFloatingActionButton(),
            body: index == 1
                ? StatsPage()
                : _buildHomePageBody(state, todayTotal),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(30),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 3,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.home,
              size: context.setMinSize(24),
              color: index == 0 ? selectedItem : unselectedItem,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.graph_square_fill,
              size: context.setMinSize(24),
              color: index == 1 ? selectedItem : unselectedItem,
            ),
            label: 'Stats',
          )
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: addNewExpense,
      shape: const CircleBorder(),
      child: SizeProvider(
        baseSize: Size(60, 60),
        width: context.setMinSize(60),
        height: context.setMinSize(60),
        child: Builder(builder: (context) {
          return Container(
            width: context.sizeProvider.width,
            height: context.sizeProvider.height,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.kOrangeColor,
                  AppColors.kPurpleColor,
                  AppColors.kBlueColor,
                ],
                transform: const GradientRotation(pi / 4),
              ),
            ),
            child: Icon(
              CupertinoIcons.add,
              size: context.setMinSize(24),
              color: Colors.white,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHomePageBody(ExpenseLoaded state, double todayTotal) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.setMinSize(18),
          vertical: context.setMinSize(10),
        ),
        child: Column(
          children: [
            SizedBox(height: context.setHeight(4)),
            _buildHeader(),
            SizedBox(height: context.setHeight(6)),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: context.setHeight(10)),
                    _buildTotalBalanceCard(todayTotal),
                    SizedBox(height: context.setHeight(14)),
                    _buildTodayTransactionsTitle(),
                    SizedBox(height: context.setHeight(8)),
                    _buildTodayTransactionsList(state),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Image.asset(
          'assets/master/logo.png',
          width: context.setWidth(48),
        ),
        SizedBox(width: context.setWidth(8)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome again!",
              style: TextStyle(
                fontSize: context.setSp(14),
                fontWeight: FontWeight.w600,
                color: AppColors.kFontColor,
              ),
            ),
            Text(
              "To Pockito.",
              style: TextStyle(
                fontSize: context.setSp(18),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF293B53),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildTotalBalanceCard(double todayTotal) {
    return SizeProvider(
      baseSize: Size(600, 160),
      width: context.setMinSize(600),
      height: context.setMinSize(160),
      child: Builder(builder: (context) {
        return Container(
          width: context.sizeProvider.width,
          height: context.sizeProvider.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/card_background.png'),
              fit: BoxFit.cover,
            ),
            gradient: LinearGradient(
              colors: [
                AppColors.kBlueColor,
                AppColors.kPurpleColor,
                AppColors.kOrangeColor,
              ],
              transform: const GradientRotation(pi / 4),
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: Colors.grey.shade300,
                offset: const Offset(5, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total Balance',
                style: TextStyle(
                  fontSize: context.setSp(18),
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: context.setHeight(18)),
              Text(
                '\£ ${todayTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: context.setSp(40),
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTodayTransactionsTitle() {
    return Row(
      children: [
        Text(
          'Today Transactions',
          style: TextStyle(
            fontSize: context.setSp(18),
            fontWeight: FontWeight.bold,
            color: AppColors.kFontColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTodayTransactionsList(ExpenseLoaded state) {
    List<ExpenseItem> todayExpenses = state.expenses.where((expense) {
      return expense.dateTime.day == DateTime.now().day &&
          expense.dateTime.month == DateTime.now().month &&
          expense.dateTime.year == DateTime.now().year;
    }).toList();

    if (todayExpenses.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(
          top: context.setMinSize(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              height: context.setHeight(260),
              image: AssetImage(
                'assets/images/no_expenses.png',
              ),
            ),
            Text(
              "No expenses recorded today.",
              style: TextStyle(
                fontSize: context.setSp(16),
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: todayExpenses.length,
      itemBuilder: (context, index) {
        return ExpenseTile(
          name: todayExpenses[index].name,
          amount: todayExpenses[index].amount,
          dateTime: todayExpenses[index].dateTime,
          deleteTapped: (BuildContext context) {
            deleteExpense(todayExpenses[index]);
          },
        );
      },
    );
  }
}
