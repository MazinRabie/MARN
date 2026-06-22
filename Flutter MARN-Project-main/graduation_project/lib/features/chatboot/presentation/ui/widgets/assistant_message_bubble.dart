import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/date_formatter.dart';
import 'package:MARN/features/chatboot/domain/entities/assistant_message_entity.dart';
import 'package:MARN/features/chatboot/presentation/ui/widgets/assistant_message_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

class AssistantMessageBubble extends StatelessWidget {
  final AssistantMessageEntity message;

  const AssistantMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.role == 'user';

    final validImages = message.imagePaths
        .where((path) => path.trim().isNotEmpty)
        .toList();

    Widget bubbleWidget = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isMe ? AppColors.primary : AppColors.primaryContainer,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: isMe
              ? const Radius.circular(16)
              : const Radius.circular(0),
          bottomRight: isMe
              ? const Radius.circular(0)
              : const Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (validImages.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: AssistantMessageImages(images: validImages),
            ),
          ],
          if (isMe)
            Text(message.content, style: AppTextStyles.chatMessageMe)
          else
            MarkdownBody(
              data: message.content,
              onTapLink: (text, href, title) async {
                if (href != null) {
                  final uri = Uri.tryParse(href);
                  if (uri != null) {
                    final pathSegments = uri.pathSegments;
                    // Check if path has 'property' and a numeric ID
                    if (pathSegments.contains('property')) {
                      final propertyIndex = pathSegments.indexOf('property');
                      if (propertyIndex != -1 &&
                          propertyIndex + 1 < pathSegments.length) {
                        final propertyIdStr = pathSegments[propertyIndex + 1];
                        final propertyId = int.tryParse(propertyIdStr);
                        if (propertyId != null) {
                          // Navigate to property details screen directly inside the app!
                          context.push('/property/$propertyId');
                          return;
                        }
                      }
                    }

                    // Fallback to launching in external browser
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                }
              },
              imageBuilder: (uri, title, alt) {
                final imageUrl = uri.toString();
                return GestureDetector(
                  onTap: () => AssistantMessageImages.showFullScreenImage(
                    context,
                    imageUrl,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(
                              Icons.broken_image_rounded,
                              color: AppColors.error,
                              size: 32,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                  .copyWith(
                    p: AppTextStyles.chatMessageOther.copyWith(height: 1.5),
                    strong: AppTextStyles.chatMessageOther.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                    em: AppTextStyles.chatMessageOther.copyWith(
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                    listBullet: AppTextStyles.chatMessageOther.copyWith(
                      height: 1.5,
                    ),
                    listBulletPadding: const EdgeInsets.only(right: 8, left: 4),
                    blockSpacing: 10,
                    a: AppTextStyles.chatMessageOther.copyWith(
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                      height: 1.5,
                    ),
                    tableHead: AppTextStyles.chatMessageOther.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                    tableBody: AppTextStyles.chatMessageOther.copyWith(
                      height: 1.5,
                    ),
                    tableBorder: TableBorder.all(
                      color: AppColors.divider,
                      width: 1,
                    ),
                    tableCellsPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    code: AppTextStyles.chatMessageOther.copyWith(
                      fontFamily: 'monospace',
                      backgroundColor: AppColors.divider.withOpacity(0.5),
                    ),
                    codeblockDecoration: BoxDecoration(
                      color: AppColors.divider.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
            ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormatter.format(message.createdAt),
                style: isMe
                    ? AppTextStyles.chatTimeMe
                    : AppTextStyles.chatTimeOther,
              ),
            ],
          ),
        ],
      ),
    );

    Offset tapPosition = Offset.zero;

    bubbleWidget = GestureDetector(
      onTapDown: (details) {
        tapPosition = details.globalPosition;
      },
      onLongPress: () async {
        final overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;
        final result = await showMenu<String>(
          context: context,
          position: RelativeRect.fromRect(
            Rect.fromLTWH(tapPosition.dx, tapPosition.dy, 30, 30),
            Offset.zero & overlay.size,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: AppColors.surface,
          elevation: 8,
          items: [
            PopupMenuItem(
              value: 'copy',
              child: Row(
                children: [
                  const Icon(
                    Icons.copy_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    LocaleKeys.chatMessagesCopy.tr(),
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        );

        if (result == 'copy') {
          Clipboard.setData(ClipboardData(text: message.content));
        }
      },
      child: bubbleWidget,
    );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: bubbleWidget,
      ),
    );
  }
}
