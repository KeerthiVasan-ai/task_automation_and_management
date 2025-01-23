import '../model/ticket.dart';

abstract class TicketEvent {}

class AddTicketEvent extends TicketEvent {
  final Ticket ticket;

  AddTicketEvent(this.ticket);
}

class FetchTicketsEvent extends TicketEvent {}
