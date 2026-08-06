import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/widgets/shimmer/app_list_shimmer.dart';
import 'package:go_router/go_router.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';

class FilteredUsersScreen extends ConsumerWidget {
  final String type;
  final int id;
  final String title;
  const FilteredUsersScreen({
    super.key,
    required this.type,
    required this.id,
    required this.title,
  });

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final surface = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final cardBg = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final asyncState = ref.watch(userNotifierProvider);
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return Scaffold(
      backgroundColor: bg,
      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      appBar: AppBar(
        title: Text(
          'Users in $title',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        backgroundColor: surface,
        surfaceTintColor: Pallets.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        shape: Border(bottom: BorderSide(color: border, width: 1)),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      body: asyncState.when(
        loading: () => AppListShimmer(itemCount: 6),
        error: (e, _) => Center(
          child: Text('Error: $e', style: TextStyle(color: textSecondary)),
        ),
        data: (state) {
          final filtered = state.users.where((user) {
            if (type == 'role') {
              return user.roleId == id;
            } else {
              return user.departmentId == id;
            }
          }).toList();
          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Pallets.infoTint,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.people_outline_rounded,
                      size: 40,
                      color: Pallets.blurple,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No users found',
                    style: TextStyle(
                      color: textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }
          //////////////////////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////////////////////

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: filtered.length,
            itemBuilder: (_, i) {
              final user = filtered[i];
              final hasAvatar =
                  user.avatarUrl != null && user.avatarUrl!.isNotEmpty;
              //////////////////////////////////////////////////////////////////
              ///
              //////////////////////////////////////////////////////////////////
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: border, width: 1),
                ),
                child: Material(
                  color: Pallets.transparent,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => context.push('/users/detail', extra: user),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Pallets.blurple.withOpacity(
                              isDark ? 0.2 : 0.12,
                            ),
                            backgroundImage: hasAvatar
                                ? NetworkImage(user.avatarUrl!)
                                : null,
                            child: !hasAvatar
                                ? Text(
                                    user.fullName.isNotEmpty
                                        ? user.fullName[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Pallets.blurple,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.fullName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.5,
                                    color: textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '@${user.username}',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: textSecondary,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
