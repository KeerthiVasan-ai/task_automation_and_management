import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/ticket.dart';

class TicketRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTicket(Ticket ticket) async {
    await _firestore.collection('tickets').doc(ticket.id).set(ticket.toJson());
  }

  Stream<List<Ticket>> fetchTickets() {
    return _firestore.collection('tickets').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Ticket.fromJson(doc.data())).toList();
    });
  }
}
