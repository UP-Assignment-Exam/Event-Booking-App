import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const CachedImage({
    Key? key,
    required this.url,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
  }) : super(key: key);

  // Guards against null, NaN, infinite, or zero dimensions
  int? _safeDimension(double? value) {
    if (value == null || value.isNaN || !value.isFinite || value <= 0) return null;
    return value.round().clamp(1, 2048);
  }

  @override
  Widget build(BuildContext context) {
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: url,
        height: height,
        width: width,
        fit: fit,
        memCacheHeight: _safeDimension(height != null ? height! * pixelRatio : null),
        memCacheWidth: _safeDimension(width != null ? width! * pixelRatio : null),
        maxHeightDiskCache: _safeDimension(height != null ? height! * 2 : null),
        maxWidthDiskCache: _safeDimension(width != null ? width! * 2 : null),
        placeholder: (context, url) => Container(
          color: Colors.grey[300],
          alignment: Alignment.center,
          child: const SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[800],
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image, color: Colors.white54, size: 42),
        ),
      ),
    );
  }
}
