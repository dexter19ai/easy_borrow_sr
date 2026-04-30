import 'package:flutter/material.dart';

import '../../models/resident_user.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.onProfileUpdated});

  final VoidCallback onProfileUpdated;

  Future<void> _openEditProfileModal(BuildContext context) async {
    final ResidentUser? resident = AppState.currentResident;
    if (resident == null) {
      return;
    }

    final TextEditingController nameController =
        TextEditingController(text: resident.fullName);
    final TextEditingController addressController =
        TextEditingController(text: resident.address);
    final TextEditingController contactController =
        TextEditingController(text: resident.contactNumber);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final bool? didUpdate = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Full name is required.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address (Optional)',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: contactController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Contact Number',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Contact number is required.';
                        }
                        final String digitsOnly = value.replaceAll(RegExp(r'\D'), '');
                        if (digitsOnly.length < 10) {
                          return 'Please provide a valid contact number.';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                AppState.updateProfile(
                  fullName: nameController.text.trim(),
                  address: addressController.text.trim(),
                  contactNumber: contactController.text.trim(),
                );
                Navigator.of(context).pop(true);
              },
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    addressController.dispose();
    contactController.dispose();

    if (didUpdate == true && context.mounted) {
      onProfileUpdated();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ResidentUser? resident = AppState.currentResident;
    if (resident == null) {
      return const Center(child: Text('No profile data found.'));
    }

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.pageGradient),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Color(0xFFDCE9FF),
                        child: Icon(Icons.person_outline, color: AppColors.primary),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Resident Profile',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _ProfileRow(label: 'Full Name', value: resident.fullName),
                  _ProfileRow(
                    label: 'Address',
                    value: resident.address.isEmpty ? 'Not provided' : resident.address,
                  ),
                  _ProfileRow(label: 'Contact Number', value: resident.contactNumber),
                  _ProfileRow(label: 'Username', value: resident.username),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    onPressed: () => _openEditProfileModal(context),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit Profile'),
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

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.mutedText,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
