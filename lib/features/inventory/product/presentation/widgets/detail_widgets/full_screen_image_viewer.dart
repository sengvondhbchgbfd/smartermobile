import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/product/domain/entities/product_entity.dart';

class FullScreenImageViewer extends StatefulWidget {
  final List<ProductImageEntity> images;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}
////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  //////////////////////////////////////////////////////////////////////////////

  late final PageController _controller = PageController(
    initialPage: widget.initialIndex,
  );
  late int _index = widget.initialIndex;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            ////////////////////////////////////////////////////////////////////
            ///
            ////////////////////////////////////////////////////////////////////
            PageView.builder(
              /////////////////////
              ///
              ////////////////////
              controller: _controller,
              itemCount: widget.images.length,
              onPageChanged: (i) => setState(() => _index = i),

              /////////////////////
              ///
              ////////////////////
              itemBuilder: (context, i) {
                /////////////////////
                ///
                ////////////////////
                final img = widget.images[i];
                if (img.imageUrl == null) return const SizedBox.shrink();
                /////////////////////
                ///
                ////////////////////
                return InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Center(
                    child: Hero(
                      tag: 'product-image-$i',
                      child: Image.network(img.imageUrl!, fit: BoxFit.contain),
                    ),
                  ),
                );
                /////////////////////
                ///
                ////////////////////
              },
            ),

            ////////////////////////////////////////////////////////////////////
            ///
            ////////////////////////////////////////////////////////////////////
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white, size: 26),
              ),
            ),

            ////////////////////////////////////////////////////////////////////
            ///
            ////////////////////////////////////////////////////////////////////
            if (widget.images.length > 1)
              Positioned(
                top: 10,
                left: 0,
                right: 0,

                child: Center(
                  child: Container(
                    ///////////////////
                    ///
                    //////////////////
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    //////////////////
                    ///
                    /////////////////
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    //////////////////
                    ///
                    /////////////////
                    child: Text(
                      '${_index + 1} / ${widget.images.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ),
              ),
            ////////////////////////////////////////////////////////////////////
            ///
            ////////////////////////////////////////////////////////////////////
          ],
        ),
      ),
    );
  }
}
