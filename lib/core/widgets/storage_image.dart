import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import 'package:narrata/core/services/download_service.dart';

final storageUrlProvider = FutureProvider.family<String, String>((ref, path) async {
  if (path.isEmpty) return '';
  return await FirebaseStorage.instance.ref(path).getDownloadURL();
});

final localThumbPathProvider = FutureProvider.family<String?, String>((ref, id) async {
  if (id.isEmpty) return null;
  return await ref.read(downloadedStoriesProvider.notifier).getLocalThumbnailPath(id);
});

class StorageImage extends ConsumerWidget {
  final String path;
  final String? localFallbackId;
  final BoxFit fit;

  const StorageImage({
    super.key,
    required this.path,
    this.localFallbackId,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (localFallbackId != null) {
      final localPathAsync = ref.watch(localThumbPathProvider(localFallbackId!));
      return localPathAsync.when(
        data: (localPath) {
          if (localPath != null) {
            return Image.file(
              File(localPath),
              fit: fit,
              errorBuilder: (context, error, stackTrace) =>
                  _buildPlaceholder(context, isError: true),
            );
          }
          return _buildNetworkImage(context, ref);
        },
        loading: () => _buildNetworkImage(context, ref),
        error: (error, stackTrace) => _buildNetworkImage(context, ref),
      );
    }
    
    return _buildNetworkImage(context, ref);
  }

  Widget _buildNetworkImage(BuildContext context, WidgetRef ref) {
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
      error: (error, stackTrace) => _buildPlaceholder(context, isError: true),
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
