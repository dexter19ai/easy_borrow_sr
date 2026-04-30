import 'equipment.dart';

enum BorrowStatus { borrowed, returned }

class BorrowRequest {
  BorrowRequest({
    required this.id,
    required this.residentUsername,
    required this.equipment,
    required this.quantity,
    required this.purpose,
    required this.borrowDate,
    required this.returnDate,
    required this.requestedAt,
    this.status = BorrowStatus.borrowed,
  });

  final String id;
  final String residentUsername;
  final Equipment equipment;
  final int quantity;
  final String purpose;
  final DateTime borrowDate;
  final DateTime returnDate;
  final DateTime requestedAt;
  BorrowStatus status;
}

extension BorrowStatusLabel on BorrowStatus {
  String get label {
    switch (this) {
      case BorrowStatus.borrowed:
        return 'Borrowed';
      case BorrowStatus.returned:
        return 'Returned';
    }
  }
}
