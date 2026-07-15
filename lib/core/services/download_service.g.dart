// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DownloadedStories)
final downloadedStoriesProvider = DownloadedStoriesProvider._();

final class DownloadedStoriesProvider
    extends $NotifierProvider<DownloadedStories, Map<String, Story>> {
  DownloadedStoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadedStoriesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadedStoriesHash();

  @$internal
  @override
  DownloadedStories create() => DownloadedStories();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, Story> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, Story>>(value),
    );
  }
}

String _$downloadedStoriesHash() => r'98d58c7cff45012222facbc109967ae0c8d0061f';

abstract class _$DownloadedStories extends $Notifier<Map<String, Story>> {
  Map<String, Story> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Map<String, Story>, Map<String, Story>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, Story>, Map<String, Story>>,
              Map<String, Story>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
