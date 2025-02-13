part of 'expense_cubit.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<ExpenseItem> expenses;

  const ExpenseLoaded(this.expenses);

  @override
  List<Object> get props => [expenses];
}
