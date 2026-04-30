import 'package:flutter/material.dart';

import '../../models/borrow_request.dart';
import '../../models/equipment.dart';
import '../../models/resident_user.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/borrow_request_modal.dart';
import '../../widgets/hover_scale.dart';

class EquipmentListScreen extends StatelessWidget {
  const EquipmentListScreen({super.key, required this.onStateUpdate});

  final VoidCallback onStateUpdate;

  Future<void> _openBorrowModal(BuildContext context, Equipment equipment) async {
    final BorrowRequestPayload? payload = await showBorrowRequestModal(
      context: context,
      equipment: equipment,
    );

    if (payload == null) {
      return;
    }

    final ResidentUser? resident = AppState.currentResident;
    if (resident == null) {
      return;
    }

    if (payload.quantity > equipment.quantityAvailable) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.danger,
          content: Text(
            'Only ${equipment.quantityAvailable} unit(s) of ${equipment.name} are available.',
          ),
        ),
      );
      return;
    }

    equipment.quantityAvailable -= payload.quantity;
    AppState.myRequests.insert(
      0,
      BorrowRequest(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        residentUsername: resident.username,
        equipment: equipment,
        quantity: payload.quantity,
        purpose: payload.purpose,
        borrowDate: payload.borrowDate,
        returnDate: payload.returnDate,
        requestedAt: DateTime.now(),
      ),
    );

    onStateUpdate();
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.success,
        content: Text('Your request has been successfully submitted.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int totalQuantity = AppState.totalItemsAvailable();

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.pageGradient),
      child: Column(
        children: [
          _EquipmentHeader(totalQuantity: totalQuantity),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;
                int columns = 1;
                if (width >= 1200) {
                  columns = 4;
                } else if (width >= 900) {
                  columns = 3;
                } else if (width >= 620) {
                  columns = 2;
                }

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: AppState.inventory.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.82,
                  ),
                  itemBuilder: (context, index) {
                    final Equipment item = AppState.inventory[index];
                    return _EquipmentCard(
                      item: item,
                      onBorrow: () => _openBorrowModal(context, item),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EquipmentHeader extends StatelessWidget {
  const _EquipmentHeader({required this.totalQuantity});

  final int totalQuantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Equipment',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$totalQuantity total units ready for borrowing.',
            style: const TextStyle(color: Color(0xFFDBEAFE)),
          ),
          const SizedBox(height: 10),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _CategoryPill(label: 'Furniture'),
              _CategoryPill(label: 'Event Equipment'),
              _CategoryPill(label: 'Sports Equipment'),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(38),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _EquipmentCard extends StatelessWidget {
  const _EquipmentCard({
    required this.item,
    required this.onBorrow,
  });

  final Equipment item;
  final VoidCallback onBorrow;

  @override
  Widget build(BuildContext context) {
    final bool hasStock = item.quantityAvailable > 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBEAFE),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.icon, color: AppColors.primary, size: 24),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    item.category,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.mutedText,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: hasStock ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                hasStock ? 'Available: ${item.quantityAvailable}' : 'Out of stock',
                style: TextStyle(
                  color: hasStock ? AppColors.success : AppColors.danger,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 10),
            HoverScale(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: hasStock ? onBorrow : null,
                  child: const Text('Borrow'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
