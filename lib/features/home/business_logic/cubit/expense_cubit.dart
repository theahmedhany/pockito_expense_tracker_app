import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/database/hive_database.dart';
import '../../data/models/expense_item.dart';

part 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final HiveDatabase db;

  ExpenseCubit(this.db) : super(ExpenseInitial()) {
    loadExpenses();
  }

  void loadExpenses() {
    final expenses = db.readData();
    emit(ExpenseLoaded(expenses));
  }

  void addExpense(ExpenseItem expense) {
    final currentState = state;
    if (currentState is ExpenseLoaded) {
      final updatedList = List<ExpenseItem>.from(currentState.expenses)
        ..add(expense);
      db.saveData(updatedList);
      emit(ExpenseLoaded(updatedList));
    }
  }

  void deleteExpense(ExpenseItem expense) {
    final currentState = state;
    if (currentState is ExpenseLoaded) {
      final updatedList = List<ExpenseItem>.from(currentState.expenses)
        ..remove(expense);
      db.saveData(updatedList);
      emit(ExpenseLoaded(updatedList));
    }
  }
}
