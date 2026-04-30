import 'package:flutter/material.dart';

import '../../models/borrow_request.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/hover_scale.dart';

class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key, required this.onStateUpdate});

  final VoidCallback onStateUpdate;

  void _returnItem(BuildContext context, BorrowRequest request) {
    request.status = BorrowStatus.returned;
    request.equipment.quantityAvailable += request.quantity;
    onStateUpdate();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.success,
        content: Text(
          'Item successfully returned. Thank you for using EasyBorrow San Ramon!',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<BorrowRequest> requests = AppState.requestsForCurrentResident();

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.pageGradient),
      child: requests.isEmpty
          ? const _EmptyRequests()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: requests.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final BorrowRequest request = requests[index];
                final bool isBorrowed = request.status == BorrowStatus.borrowed;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDBEAFE),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                request.equipment.icon,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    request.equipment.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Quantity: ${request.quantity}',
                                    style: const TextStyle(
                                      color: AppColors.mutedText,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Borrow Date: ${formatDate(request.borrowDate)}',
                                    style: const TextStyle(color: AppColors.mutedText),
                                  ),
                                  Text(
                                    'Return Date: ${formatDate(request.returnDate)}',
                                    style: const TextStyle(color: AppColors.mutedText),
                                  ),
                                ],
                              ),
                            ),
                            _StatusBadge(status: request.status),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Text(
                            'Purpose: ${request.purpose}',
                            style: const TextStyle(color: AppColors.ink),
                          ),
                        ),
                        if (isBorrowed) ...[
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: HoverScale(
                              child: ElevatedButton.icon(
                                onPressed: () => _returnItem(context, request),
                                icon: const Icon(Icons.keyboard_return),
                                label: const Text('Return'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(130, 44),
                                  backgroundColor: AppColors.danger,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final BorrowStatus status;

  @override
  Widget build(BuildContext context) {
    final bool isBorrowed = status == BorrowStatus.borrowed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isBorrowed ? const Color(0xFFFEF3C7) : const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: isBorrowed ? const Color(0xFFB45309) : const Color(0xFF166534),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptyRequests extends StatelessWidget {
  const _EmptyRequests();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.assignment_late_outlined,
                  size: 58,
                  color: Color(0xFF64748B),
                ),
                SizedBox(height: 12),
                Text(
                  'No Borrow Requests Yet',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Borrow equipment from the Available Equipment page and your requests will appear here.',
                  style: TextStyle(color: AppColors.mutedText),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
