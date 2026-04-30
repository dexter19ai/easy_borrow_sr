import 'package:flutter/material.dart';

import '../../models/borrow_request.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/date_formatter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onOpenEquipment,
    required this.onOpenRequests,
  });

  final VoidCallback onOpenEquipment;
  final VoidCallback onOpenRequests;

  @override
  Widget build(BuildContext context) {
    final String fullName = AppState.currentResident?.fullName ?? 'Resident';
    final List<BorrowRequest> requests = AppState.requestsForCurrentResident();

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.pageGradient),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _WelcomeBanner(fullName: fullName),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isCompact = constraints.maxWidth < 700;
              final List<Widget> cards = [
                _SummaryCard(
                  title: 'Total Items Available',
                  value: AppState.totalItemsAvailable().toString(),
                  icon: Icons.inventory_2_outlined,
                  color: AppColors.primary,
                ),
                _SummaryCard(
                  title: 'Active Borrowed Items',
                  value: AppState.activeBorrowedItemsCount().toString(),
                  icon: Icons.assignment_turned_in_outlined,
                  color: AppColors.warning,
                ),
                _SummaryCard(
                  title: 'Returned Items',
                  value: AppState.returnedItemsCount().toString(),
                  icon: Icons.check_circle_outline,
                  color: AppColors.success,
                ),
              ];

              if (isCompact) {
                return Column(
                  children: cards
                      .map((card) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: card,
                          ))
                      .toList(),
                );
              }

              return Row(
                children: cards
                    .map((card) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: card,
                          ),
                        ))
                    .toList()
                  ..removeLast()
                  ..add(Expanded(child: cards.last)),
              );
            },
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Actions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Access key pages quickly using these shortcuts.',
                    style: TextStyle(color: AppColors.mutedText),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _ActionButton(
                        label: 'Browse Equipment',
                        icon: Icons.inventory_2,
                        onTap: onOpenEquipment,
                      ),
                      _ActionButton(
                        label: 'View My Requests',
                        icon: Icons.assignment,
                        onTap: onOpenRequests,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent Request Activity',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  if (requests.isEmpty)
                    const Text(
                      'No requests yet. Borrow equipment to see your activity here.',
                      style: TextStyle(color: AppColors.mutedText),
                    )
                  else
                    ...requests.take(3).map(
                          (request) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _RecentRequestTile(request: request),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  const _WelcomeBanner({required this.fullName});

  final String fullName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome to EasyBorrow San Ramon',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hello, $fullName. Borrow and track barangay equipment with ease.',
            style: const TextStyle(
              color: Color(0xFFE0EAFF),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withAlpha(38),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.ink,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.mutedText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(190, 48),
      ),
    );
  }
}

class _RecentRequestTile extends StatelessWidget {
  const _RecentRequestTile({required this.request});

  final BorrowRequest request;

  @override
  Widget build(BuildContext context) {
    final bool isBorrowed = request.status == BorrowStatus.borrowed;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFF8FAFC),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(request.equipment.icon, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.equipment.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  'Borrow Date: ${formatDate(request.borrowDate)}',
                  style: const TextStyle(color: AppColors.mutedText, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: isBorrowed ? const Color(0xFFFEF3C7) : const Color(0xFFDCFCE7),
            ),
            child: Text(
              request.status.label,
              style: TextStyle(
                color: isBorrowed ? const Color(0xFFB45309) : const Color(0xFF166534),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
