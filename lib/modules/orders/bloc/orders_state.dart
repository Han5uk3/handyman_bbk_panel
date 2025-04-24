part of 'orders_bloc.dart';

sealed class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

final class OrdersInitial extends OrdersState {}

class MarkingLoadingState extends OrdersState {}

class MarkingSuccessState extends OrdersState {}

class MarkingErrorState extends OrdersState {
  final String message;
  const MarkingErrorState(this.message);
  @override
  List<Object> get props => [message];
}
