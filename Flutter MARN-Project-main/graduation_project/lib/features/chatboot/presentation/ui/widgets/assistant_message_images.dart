import 'package:MARN/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AssistantMessageImages extends StatelessWidget {
  final List<String> images;

  const AssistantMessageImages({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    final validImages = images.where((path) => path.trim().isNotEmpty).toList();
    if (validImages.isEmpty) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: _buildImagesWidget(context, validImages),
    );
  }

  Widget _buildImagesWidget(BuildContext context, List<String> imgs) {
    if (imgs.length == 1) {
      return GestureDetector(
        onTap: () => _showFullScreenImage(context, imgs[0]),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Image.network(
            imgs[0],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildErrorImage(),
          ),
        ),
      );
    } else if (imgs.length == 2) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _showFullScreenImage(context, imgs[0]),
                child: Image.network(
                  imgs[0],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildErrorImage(),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: GestureDetector(
                onTap: () => _showFullScreenImage(context, imgs[1]),
                child: Image.network(
                  imgs[1],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildErrorImage(),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: imgs.length > 4 ? 4 : imgs.length,
          itemBuilder: (context, index) {
            final imageUrl = imgs[index];
            if (index == 3 && imgs.length > 4) {
              return GestureDetector(
                onTap: () => _showFullScreenImage(context, imageUrl),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildErrorImage(),
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: Text(
                          '+${imgs.length - 3}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Alexandria',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return GestureDetector(
              onTap: () => _showFullScreenImage(context, imageUrl),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildErrorImage(),
              ),
            );
          },
        ),
      );
    }
  }

  Widget _buildErrorImage() {
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
  }

  static void showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(dialogContext),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.9),
              ),
            ),
            InteractiveViewer(
              clipBehavior: Clip.none,
              maxScale: 4.0,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
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
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(dialogContext),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showFullScreenImage(context, imageUrl);
  }
}
