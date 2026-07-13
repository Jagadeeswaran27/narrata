// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(storyRepository)
final storyRepositoryProvider = StoryRepositoryProvider._();

final class StoryRepositoryProvider
    extends
        $FunctionalProvider<StoryRepository, StoryRepository, StoryRepository>
    with $Provider<StoryRepository> {
  StoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storyRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storyRepositoryHash();

  @$internal
  @override
  $ProviderElement<StoryRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StoryRepository create(Ref ref) {
    return storyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StoryRepository>(value),
    );
  }
}

String _$storyRepositoryHash() => r'81a2f1af5d7562d41117f4c23db7c1ea7261cf76';
