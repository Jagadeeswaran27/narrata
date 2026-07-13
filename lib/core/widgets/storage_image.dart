import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

final storageUrlProvider = FutureProvider.family<String, String>((ref, path) async {
  if (path.isEmpty) return '';
  return await FirebaseStorage.instance.ref(path).getDownloadURL();
});

class StorageImage extends ConsumerWidget {
  final String path;
  final BoxFit fit;

  const StorageImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (path.isEmpty) {
      return _buildPlaceholder(context);
    }

    final urlAsync = ref.watch(storageUrlProvider(path));

    return urlAsync.when(
      data: (url) {
        if (url.isEmpty) return _buildPlaceholder(context);
        return CachedNetworkImage(
          imageUrl: url,
          fit: fit,
          fadeInDuration: const Duration(milliseconds: 300),
          placeholder: (context, url) => _buildPlaceholder(context),
          errorWidget: (context, url, error) => _buildPlaceholder(context, isError: true),
        );
      },
      loading: () => _buildPlaceholder(context),
      error: (_, __) => _buildPlaceholder(context, isError: true),
    );
  }

  Widget _buildPlaceholder(BuildContext context, {bool isError = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    
    if (isError) {
      return Container(
        color: colorScheme.surfaceContainerHighest,
        child: Center(
          child: Icon(
            Icons.broken_image,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    return Shimmer.fromColors(
      baseColor: colorScheme.primary.withValues(alpha: 0.1),
      highlightColor: colorScheme.primary.withValues(alpha: 0.3),
      child: Container(
        color: Colors.white,
      ),
    );
  }
}
