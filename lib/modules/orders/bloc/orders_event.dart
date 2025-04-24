part of 'orders_bloc.dart';

sealed class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object> get props => [];
}

class MarkAsPackedEvent extends OrdersEvent {
  final String orderId;
  const MarkAsPackedEvent({required this.orderId});
}
