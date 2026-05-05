import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontendmobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authProvider, (previous, next) {
      if (next is AsyncData && next.value == null) {
        context.go('/login');
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Logout failed: ${next.error}')));
      }
    });

    final authState = ref.watch(authProvider);
    final isLoading = authState is AsyncLoading;
    final companyIdAsync = ref.watch(companyIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          isLoading
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await ref.read(authProvider.notifier).logout();
                  },
                ),
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome!', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),

            /// ✅ Correct Riverpod way (NO FutureBuilder)
            companyIdAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, _) => Text('Error: $error'),
              data: (companyId) {
                if (companyId == null) {
                  return const Text("Company not found");
                }

                return ElevatedButton.icon(
                  icon: const Icon(Icons.business),
                  label: const Text('Go to Company'),
                  onPressed: () {
                    context.push('/company/$companyId');
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
