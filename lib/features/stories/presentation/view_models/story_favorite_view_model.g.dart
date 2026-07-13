// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_favorite_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(storyFavoriteStatus)
final storyFavoriteStatusProvider = StoryFavoriteStatusFamily._();

final class StoryFavoriteStatusProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  StoryFavoriteStatusProvider._({
    required StoryFavoriteStatusFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'storyFavoriteStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$storyFavoriteStatusHash();

  @override
  String toString() {
    return r'storyFavoriteStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    final argument = this.argument as String;
    return storyFavoriteStatus(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StoryFavoriteStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$storyFavoriteStatusHash() =>
    r'b3d1f4743c34b0152d71c640658c53e07ed41a50';

final class StoryFavoriteStatusFamily extends $Family
    with $FunctionalFamilyOverride<Stream<bool>, String> {
  StoryFavoriteStatusFamily._()
    : super(
        retry: null,
        name: r'storyFavoriteStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StoryFavoriteStatusProvider call(String storyId) =>
      StoryFavoriteStatusProvider._(argument: storyId, from: this);

  @override
  String toString() => r'storyFavoriteStatusProvider';
}

@ProviderFor(StoryFavoriteAction)
final storyFavoriteActionProvider = StoryFavoriteActionProvider._();

final class StoryFavoriteActionProvider
    extends $AsyncNotifierProvider<StoryFavoriteAction, void> {
  StoryFavoriteActionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storyFavoriteActionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storyFavoriteActionHash();

  @$internal
  @override
  StoryFavoriteAction create() => StoryFavoriteAction();
}

String _$storyFavoriteActionHash() =>
    r'e05dad83539b4888b86c4526121784922499b824';

abstract class _$StoryFavoriteAction extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
