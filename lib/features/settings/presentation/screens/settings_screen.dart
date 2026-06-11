import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/settings/presentation/providers/settings_provider.dart';
import 'package:frontendmobile/features/settings/presentation/widgets/setting_widgets.dart';

class SystemSettingsScreen extends ConsumerStatefulWidget {
  const SystemSettingsScreen({super.key});

  @override
  ConsumerState<SystemSettingsScreen> createState() =>
      _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends ConsumerState<SystemSettingsScreen> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load settings when screen opens
    Future.microtask(() => ref.read(settingsProvider.notifier).loadAll());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Dialogs ───────────────────────────────────────────────────────────────

  Future<void> _openCreateDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const SettingFormDialog(),
    );
    if (result == null || !mounted) return;

    final ok = await ref
        .read(settingsProvider.notifier)
        .create(
          key: result['key'],
          value: result['value'],
          description: result['description'],
        );

    if (mounted) {
      _showSnack(ok ? 'Setting created.' : 'Failed to create setting.');
    }
  }

  Future<void> _openEditDialog(settingId) async {
    final setting = ref
        .read(settingsProvider)
        .settings
        .firstWhere((s) => s.settingId == settingId);

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => SettingFormDialog(existing: setting),
    );
    if (result == null || !mounted) return;

    final ok = await ref
        .read(settingsProvider.notifier)
        .update(
          settingId: settingId,
          value: result['value'],
          description: result['description'],
        );

    if (mounted) {
      _showSnack(ok ? 'Setting updated.' : 'Failed to update setting.');
    }
  }

  Future<void> _confirmDelete(int settingId, String key) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => DeleteConfirmDialog(settingKey: key),
    );
    if (confirmed != true || !mounted) return;

    final ok = await ref.read(settingsProvider.notifier).delete(settingId);
    if (mounted) {
      _showSnack(ok ? 'Setting "$key" deleted.' : 'Failed to delete setting.');
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    // Filter by search
    final filtered = state.settings
        .where(
          (s) =>
              _searchQuery.isEmpty ||
              s.key.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              (s.value?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
                  false),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('System Settings'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            tooltip: 'Refresh',
            onPressed: state.isLoading ? null : notifier.loadAll,
          ),
          const SizedBox(width: 8),
        ],
      ),

      // ── FAB ──────────────────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Setting'),
      ),

      body: Column(
        children: [
          // ── Error banner ─────────────────────────────────────────────────
          if (state.error != null)
            ErrorBanner(message: state.error!, onDismiss: notifier.clearError),

          // ── Search bar ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search by key or value…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),

          // ── Count label ──────────────────────────────────────────────────
          if (state.settings.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${filtered.length} setting${filtered.length == 1 ? '' : 's'}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
            ),

          // ── List / Loading / Empty ────────────────────────────────────────
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                ? SettingsEmptyState(onAdd: _openCreateDialog)
                : RefreshIndicator(
                    onRefresh: notifier.loadAll,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final s = filtered[i];
                        return SettingTile(
                          setting: s,
                          onEdit: () => _openEditDialog(s.settingId),
                          onDelete: () => _confirmDelete(s.settingId, s.key),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
