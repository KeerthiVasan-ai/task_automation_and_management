import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/ticket.dart';
import '../repository/ticket_repository.dart';
import 'ticket_event.dart';
import 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketRepository ticketRepository;

  TicketBloc(this.ticketRepository) : super(TicketInitialState()) {
    on<AddTicketEvent>((event, emit) async {
      emit(TicketLoadingState());
      try {
        await ticketRepository.addTicket(event.ticket);
        emit(TicketInitialState());
      } catch (e) {
        emit(TicketErrorState(e.toString()));
      }
    });

    on<FetchTicketsEvent>((event, emit) async {
      emit(TicketLoadingState());
      try {
        await emit.forEach<List<Ticket>>(
          ticketRepository.fetchTickets(),
          onData: (tickets) => TicketLoadedState(tickets),
          onError: (error, stackTrace) => TicketErrorState(error.toString()),
        );
      } catch (e) {
        emit(TicketErrorState(e.toString()));
      }
    });
  }
}
