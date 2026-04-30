import 'package:flutter/material.dart';

import '../models/equipment.dart';
import '../theme/app_theme.dart';
import '../utils/date_formatter.dart';

class BorrowRequestPayload {
  BorrowRequestPayload({
    required this.quantity,
    required this.purpose,
    required this.borrowDate,
    required this.returnDate,
  });

  final int quantity;
  final String purpose;
  final DateTime borrowDate;
  final DateTime returnDate;
}

Future<BorrowRequestPayload?> showBorrowRequestModal({
  required BuildContext context,
  required Equipment equipment,
}) {
  return showDialog<BorrowRequestPayload>(
    context: context,
    builder: (_) => _BorrowRequestModal(equipment: equipment),
  );
}

class _BorrowRequestModal extends StatefulWidget {
  const _BorrowRequestModal({required this.equipment});

  final Equipment equipment;

  @override
  State<_BorrowRequestModal> createState() => _BorrowRequestModalState();
}

class _BorrowRequestModalState extends State<_BorrowRequestModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController(text: '1');
  final TextEditingController _purposeController = TextEditingController();
  DateTime? _borrowDate;
  DateTime? _returnDate;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _quantityController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  Future<void> _pickBorrowDate() async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = _borrowDate ?? now;
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      setState(() {
        _borrowDate = selectedDate;
        if (_returnDate != null && !_returnDate!.isAfter(selectedDate)) {
          _returnDate = null;
        }
      });
    }
  }

  Future<void> _pickReturnDate() async {
    final DateTime baseDate = _borrowDate ?? DateTime.now();
    final DateTime initialDate = _returnDate ?? baseDate.add(const Duration(days: 1));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: baseDate.add(const Duration(days: 1)),
      lastDate: baseDate.add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      setState(() {
        _returnDate = selectedDate;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_borrowDate == null || _returnDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.danger,
          content: Text('Please select both Date Needed and Return Date.'),
        ),
      );
      return;
    }

    if (!_returnDate!.isAfter(_borrowDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.danger,
          content: Text('Return date must be after the borrow date.'),
        ),
      );
      return;
    }

    final int quantity = int.parse(_quantityController.text.trim());
    if (quantity > widget.equipment.quantityAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.danger,
          content: Text(
            'Only ${widget.equipment.quantityAvailable} item(s) are currently available.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(
      BorrowRequestPayload(
        quantity: quantity,
        purpose: _purposeController.text.trim(),
        borrowDate: _borrowDate!,
        returnDate: _returnDate!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isCompact = MediaQuery.of(context).size.width < 640;

    return AlertDialog(
      title: const Text('Borrow Request Form'),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isCompact ? 360 : 520),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: widget.equipment.name,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    prefixIcon: Icon(Icons.inventory_2_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    prefixIcon: Icon(Icons.numbers_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Quantity is required.';
                    }
                    final int? quantity = int.tryParse(value.trim());
                    if (quantity == null || quantity <= 0) {
                      return 'Please enter a valid quantity.';
                    }
                    if (quantity > widget.equipment.quantityAvailable) {
                      return 'Requested quantity is more than available.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _purposeController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Purpose of Borrowing',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please provide your purpose of borrowing.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _DatePickerField(
                  label: 'Date Needed',
                  selectedDate: _borrowDate,
                  onTap: _pickBorrowDate,
                ),
                const SizedBox(height: 12),
                _DatePickerField(
                  label: 'Return Date',
                  selectedDate: _returnDate,
                  onTap: _pickReturnDate,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: Colors.white,
                  ),
                )
              : const Text('Submit Request'),
        ),
      ],
    );
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.label,
    required this.selectedDate,
    required this.onTap,
  });

  final String label;
  final DateTime? selectedDate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFCBD5E1)),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                selectedDate == null
                    ? label
                    : '$label: ${formatDate(selectedDate!)}',
                style: TextStyle(
                  color: selectedDate == null ? AppColors.mutedText : AppColors.ink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.expand_more_rounded),
          ],
        ),
      ),
    );
  }
}
