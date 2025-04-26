import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:handyman_bbk_panel/helpers/collections.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(OrdersInitial()) {
    on<MarkAsPackedEvent>(_markAsPacked);
  }

  void _markAsPacked(MarkAsPackedEvent event, Emitter<OrdersState> emit) async {
    try {
      await FirebaseCollections.orders
          .doc(event.orderId)
          .update({
            'isPackaged': true,
          })
          .then((value) => emit(MarkingSuccessState()))
          .catchError((e) {
            emit(MarkingErrorState(e.toString()));
          });
    } catch (e) {
      emit(MarkingErrorState(e.toString()));
    }
  }
}
