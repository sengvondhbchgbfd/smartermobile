import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/auth/data/models/auth_user_model.dart';
import 'package:frontendmobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/providers/notification_provider.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/widgets/palette.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Sheet
// ─────────────────────────────────────────────────────────────────────────────
class AdminCreateNotificationSheet extends ConsumerStatefulWidget {
  const AdminCreateNotificationSheet({super.key});

  @override
  ConsumerState<AdminCreateNotificationSheet> createState() =>
      _AdminCreateNotificationSheetState();
}

class _AdminCreateNotificationSheetState
    extends ConsumerState<AdminCreateNotificationSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();

  String _selectedType = 'info';
  bool _isLoading = false;

  // Selected users (supports multi-select; if your API takes a single userId,
  // just use _selectedUsers.first.userId)
  final Set<int> _selectedUserIds = {};
  String _searchQuery = '';

  static const _types = [
    'info',
    'alert',
    'warning',
    'success',
    'error',
    'task',
    'message',
    'system',
  ];

  @override
  void initState() {
    super.initState();
    // Load users when sheet opens
    Future.microtask(() => ref.read(userProvider.notifier).getUsers());
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _messageCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedUserIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one user'),
          backgroundColor: Pallets.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      for (final userId in _selectedUserIds) {
        await ref
            .read(notificationNotifierProvider.notifier)
            .adminCreate(
              userId: userId,
              title: _titleCtrl.text.trim(),
              message: _messageCtrl.text.trim(),
              type: _selectedType,
            );
      }
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification sent'),
            backgroundColor: Pallets.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Pallets.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final p = Palette.of(isDark);
    final usersAsync = ref.watch(userProvider);

    return Padding(
      // ✅ Lifts sheet when keyboard appears
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Form(
            key: _formKey,
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              children: [
                // ── Drag handle ───────────────────────────────────────────
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: p.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // ── Header ────────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Send Notification',
                      style: TextStyle(
                        color: p.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: p.textSecondary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Recipients ────────────────────────────────────────────
                Text(
                  'Send To',
                  style: TextStyle(color: p.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 8),

                // Selected chips preview
                if (_selectedUserIds.isNotEmpty)
                  usersAsync.whenData((users) {
                        final selected = users
                            .where((u) => _selectedUserIds.contains(u.userId))
                            .toList();
                        return Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: selected
                              .map(
                                (u) => Chip(
                                  label: Text(
                                    u.fullName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  backgroundColor: Pallets.gradient2,
                                  deleteIconColor: Colors.white70,
                                  onDeleted: () => setState(
                                    () => _selectedUserIds.remove(u.userId),
                                  ),
                                  padding: EdgeInsets.zero,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              )
                              .toList(),
                        );
                      }).value ??
                      const SizedBox.shrink(),

                if (_selectedUserIds.isNotEmpty) const SizedBox(height: 8),

                // Search box
                TextFormField(
                  controller: _searchCtrl,
                  style: TextStyle(color: p.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search users…',
                    hintStyle: TextStyle(color: p.textSecondary),
                    prefixIcon: Icon(
                      Icons.search,
                      color: p.textSecondary,
                      size: 18,
                    ),
                    filled: true,
                    fillColor: p.fillColor,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: p.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: p.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Pallets.gradient2),
                    ),
                  ),
                  onChanged: (v) =>
                      setState(() => _searchQuery = v.toLowerCase()),
                ),
                const SizedBox(height: 8),

                // ── User list ─────────────────────────────────────────────
                usersAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Pallets.gradient2,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  error: (e, _) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Failed to load users',
                      style: TextStyle(color: Pallets.error),
                    ),
                  ),
                  data: (users) {
                    final filtered = users.where((u) {
                      if (_searchQuery.isEmpty) return true;
                      return u.fullName.toLowerCase().contains(_searchQuery) ||
                          u.userId.toString().contains(_searchQuery);
                    }).toList();

                    if (filtered.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'No users found',
                          style: TextStyle(color: p.textSecondary),
                        ),
                      );
                    }

                    return Container(
                      decoration: BoxDecoration(
                        color: p.fillColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: p.border),
                      ),
                      // ✅ Fixed height so list doesn't blow out the sheet
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) =>
                            Divider(height: 1, color: p.border),
                        itemBuilder: (context, i) {
                          final user = filtered[i];
                          final isSelected = _selectedUserIds.contains(
                            user.userId,
                          );
                          return ListTile(
                            dense: true,
                            onTap: () => setState(() {
                              if (isSelected) {
                                _selectedUserIds.remove(user.userId);
                              } else {
                                _selectedUserIds.add(user.userId);
                              }
                            }),
                            leading: CircleAvatar(
                              radius: 16,
                              backgroundColor: Pallets.gradient2.withOpacity(
                                0.15,
                              ),
                              child: Text(
                                user.fullName.isNotEmpty
                                    ? user.fullName[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  color: Pallets.gradient2,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            title: Text(
                              user.fullName,
                              style: TextStyle(
                                color: p.textPrimary,
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                            subtitle: Text(
                              user.role,
                              style: TextStyle(
                                color: p.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                            trailing: isSelected
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Pallets.gradient2,
                                    size: 18,
                                  )
                                : Icon(
                                    Icons.circle_outlined,
                                    color: p.border,
                                    size: 18,
                                  ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // ── Title ─────────────────────────────────────────────────
                _Field(
                  controller: _titleCtrl,
                  label: 'Title',
                  hint: 'Notification title',
                  isDark: isDark,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),

                // ── Message ───────────────────────────────────────────────
                _Field(
                  controller: _messageCtrl,
                  label: 'Message',
                  hint: 'Notification body',
                  isDark: isDark,
                  maxLines: 3,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),

                // ── Type ──────────────────────────────────────────────────
                Text(
                  'Type',
                  style: TextStyle(color: p.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _types.map((t) {
                    final selected = t == _selectedType;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedType = t),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? Pallets.gradient2 : p.fillColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected ? Pallets.gradient2 : p.border,
                          ),
                        ),
                        child: Text(
                          t,
                          style: TextStyle(
                            color: selected ? Colors.white : p.textSecondary,
                            fontSize: 12,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // ── Submit ────────────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Pallets.gradient2,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _selectedUserIds.length > 1
                                ? 'Send to ${_selectedUserIds.length} users'
                                : 'Send',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Reusable text field ───────────────────────────────────────────────────────


class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isDark;
  final int maxLines;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    required this.isDark,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(isDark);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: p.textSecondary, fontSize: 13)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(color: p.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: p.textSecondary),
            filled: true,
            fillColor: p.fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: p.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: p.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Pallets.gradient2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Pallets.error),
            ),
          ),
        ),
      ],
    );
  }
}
