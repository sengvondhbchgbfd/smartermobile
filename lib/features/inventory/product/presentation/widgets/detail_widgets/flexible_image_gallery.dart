import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/product/domain/entities/product_entity.dart';
import 'package:frontendmobile/features/inventory/product/presentation/widgets/detail_widgets/full_screen_image_viewer.dart';

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class FlexibleImageGallery extends StatefulWidget {
  final List<ProductImageEntity> images;
  final Color cardBg;
  final ValueChanged<int> onSetPrimary;
  final ValueChanged<int> onDelete;
  final VoidCallback onAdd;

  const FlexibleImageGallery({
    super.key,
    required this.images,
    required this.cardBg,
    required this.onSetPrimary,
    required this.onDelete,
    required this.onAdd,
  });

  @override
  State<FlexibleImageGallery> createState() => FlexibleImageGalleryState();
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class FlexibleImageGalleryState extends State<FlexibleImageGallery> {
  final _pageController = PageController();
  int _index = 0;
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  void _openFullScreen(int startIndex) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (_, anim, __) => FadeTransition(
          opacity: anim,
          child: FullScreenImageViewer(
            images: widget.images,
            initialIndex: startIndex,
          ),
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  void _showImageOptions(ProductImageEntity image) {
    showModalBottomSheet(
      context: context,
      backgroundColor: widget.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            if (!image.isPrimary)
              ListTile(
                leading: const Icon(Icons.star_outline),
                title: const Text('Set as primary'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  widget.onSetPrimary(image.imageId);
                },
              ),
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: Theme.of(sheetContext).colorScheme.error,
              ),
              title: Text(
                'Delete image',
                style: TextStyle(
                  color: Theme.of(sheetContext).colorScheme.error,
                ),
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                widget.onDelete(image.imageId);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final images = widget.images;

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    if (images.isEmpty) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Container(color: widget.cardBg),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.image_outlined,
                  size: 48,
                  color: Colors.grey.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: widget.onAdd,
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  label: const Text('Add a photo'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    final validImages = images.where((i) => i.imageUrl != null).toList();
    return Stack(
      fit: StackFit.expand,
      children: [
        ////////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////////
        PageView.builder(
          controller: _pageController,
          itemCount: validImages.length,
          onPageChanged: (i) => setState(() => _index = i),
          itemBuilder: (context, i) {
            final img = validImages[i];
            return GestureDetector(
              onTap: () => _openFullScreen(i),
              onLongPress: () => _showImageOptions(img),
              child: Hero(
                tag: 'product-image-$i',
                child: Image.network(
                  img.imageUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: widget.cardBg,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stack) => Container(
                    color: widget.cardBg,
                    child: const Center(
                      child: Icon(Icons.broken_image_outlined, size: 36),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        ////////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////////

        // Bottom scrim
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0),
                  Colors.black.withValues(alpha: 0.45),
                ],
              ),
            ),
          ),
        ),

        ////////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////////

        // Dot indicator
        if (validImages.length > 1)
          Positioned(
            bottom: 64,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(validImages.length, (i) {
                final active = i == _index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 16 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: active ? 1 : 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),

        ////////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////////
        Positioned(
          bottom: 10,
          left: 12,
          right: 12,
          child: SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var i = 0; i < validImages.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => _pageController.animateToPage(
                        i,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      ),
                      onLongPress: () => _showImageOptions(validImages[i]),
                      child: Container(
                        width: 44,
                        height: 44,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: i == _index
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.4),
                            width: i == _index ? 2 : 1,
                          ),
                        ),



                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          validImages[i].imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: widget.cardBg,
                            child: const Icon(Icons.image_outlined, size: 18),
                          ),
                        ),
                      ),
                    ),
                  ),

                ////////////////////////////////////////////////////////////////
                ///
                ////////////////////////////////////////////////////////////////
                GestureDetector(
                  onTap: widget.onAdd,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withValues(alpha: 0.35),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ),

                ////////////////////////////////////////////////////////////////
                ///
                ////////////////////////////////////////////////////////////////
              ],
            ),
          ),
        ),
      ],
    );
  }
}
