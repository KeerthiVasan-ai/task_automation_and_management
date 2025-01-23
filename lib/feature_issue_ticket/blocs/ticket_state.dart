import '../model/ticket.dart';

abstract class TicketState {}

class TicketInitialState extends TicketState {}

class TicketLoadingState extends TicketState {}

class TicketLoadedState extends TicketState {
  final List<Ticket> tickets;

  TicketLoadedState(this.tickets);
}

class TicketErrorState extends TicketState {
  final String message;

  TicketErrorState(this.message);
}
