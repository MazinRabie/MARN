import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/build_loading.dart';
import 'package:MARN/features/chatboot/presentation/state_management/cubit/assistant_cubit.dart';
import 'package:MARN/features/chatboot/presentation/ui/widgets/rename_session_dialog.dart';
import 'package:MARN/features/chatboot/presentation/ui/widgets/session_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatHistoryDrawer extends StatelessWidget {
  const ChatHistoryDrawer({super.key, required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;

  void _showRenameDialog(BuildContext context, dynamic session) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return RenameSessionDialog(
          session: session,
          assistantCubit: context.read<AssistantCubit>(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.divider)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.smart_toy,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'المساعد الذكي',
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'سجل المحادثات السابقة',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // New Chat Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () {
                  context.read<AssistantCubit>().clearSession();
                  scaffoldKey.currentState?.closeEndDrawer();
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primarySecond],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, color: AppColors.white),
                      const SizedBox(width: 8),
                      Text(
                        'محادثة جديدة',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Sessions List
            Expanded(
              child: BlocBuilder<AssistantCubit, AssistantState>(
                builder: (context, state) {
                  final sessions = context.read<AssistantCubit>().sessions;
                  final currentSessionId = context
                      .read<AssistantCubit>()
                      .currentSessionId;

                  if (state is AssistantLoading && sessions.isEmpty) {
                    return buildLoading();
                  }

                  if (sessions.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline,
                            size: 48,
                            color: AppColors.grey,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'لا توجد محادثات سابقة',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      final isSelected = session.sessionId == currentSessionId;

                      return SessionListTile(
                        session: session,
                        isSelected: isSelected,
                        onRenamePressed: () {
                          _showRenameDialog(context, session);
                        },
                        onTap: () {
                          context.read<AssistantCubit>().loadSessionMessages(
                            session.sessionId,
                          );
                          scaffoldKey.currentState?.closeEndDrawer();
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
