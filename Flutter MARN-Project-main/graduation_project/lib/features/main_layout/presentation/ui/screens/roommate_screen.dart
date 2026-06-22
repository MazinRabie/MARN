import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/build_loading.dart';
import 'package:MARN/features/main_layout/presentation/state_management/cubit/roommate_cubit.dart';
import 'package:MARN/features/main_layout/presentation/ui/widgets/roommate_match_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MARN/core/widgets/top_bounce_only_scroll_physics.dart';
import 'package:go_router/go_router.dart';

class RoommateScreen extends StatefulWidget {
  const RoommateScreen({super.key});

  @override
  State<RoommateScreen> createState() => _RoommateScreenState();
}

class _RoommateScreenState extends State<RoommateScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch top 30 matches on initialization
    context.read<RoommateCubit>().getRoommateMatches(limit: 30);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: SafeArea(
        child: BlocBuilder<RoommateCubit, RoommateState>(
          builder: (context, state) {
            if (state is RoommateLoading) {
              return Center(child: buildLoading());
            } else if (state is RoommateFailure) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.error,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.errorMessage,
                        style: AppTextStyles.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          context.read<RoommateCubit>().getRoommateMatches(
                            limit: 30,
                          );
                        },
                        icon: const Icon(Icons.refresh, color: AppColors.white),
                        label: Text(
                          LocaleKeys.commonRetry.tr(),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is RoommateSuccess) {
              final matches = state.matches;
              if (matches.isEmpty) {
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async {
                    await context.read<RoommateCubit>().getRoommateMatches(
                      limit: 30,
                    );
                  },
                  child: SingleChildScrollView(
                    physics: const TopBounceOnlyScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline_rounded,
                              color: AppColors.textTertiary.withOpacity(0.5),
                              size: 80,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              LocaleKeys.roommateNoMatchesFound.tr(),
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.textTertiary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                context.push(
                                  AppRoutes.editRoommatePreferencesScreen,
                                );
                              },
                              icon: const Icon(
                                Icons.settings_suggest,
                                color: AppColors.white,
                              ),
                              label: Text(
                                LocaleKeys.roommateUpdatePreferences.tr(),
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  await context.read<RoommateCubit>().getRoommateMatches(
                    limit: 30,
                  );
                },
                child: ListView.builder(
                  physics: const TopBounceOnlyScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
                  itemCount: matches.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              LocaleKeys.roommateTitle.tr(),
                              style: AppTextStyles.titleLarge,
                            ),
                          ],
                        ),
                      );
                    }
                    final match = matches[index - 1];
                    return RoommateMatchCard(match: match);
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
