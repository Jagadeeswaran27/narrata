// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_selection_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(storiesList)
final storiesListProvider = StoriesListProvider._();

final class StoriesListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Story>>,
          List<Story>,
          FutureOr<List<Story>>
        >
    with $FutureModifier<List<Story>>, $FutureProvider<List<Story>> {
  StoriesListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storiesListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storiesListHash();

  @$internal
  @override
  $FutureProviderElement<List<Story>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Story>> create(Ref ref) {
    return storiesList(ref);
  }
}

String _$storiesListHash() => r'a5e7384be2325b9a15f3aeed0dfb2b6309c2f7bf';

@ProviderFor(SelectedStories)
final selectedStoriesProvider = SelectedStoriesProvider._();

final class SelectedStoriesProvider
    extends $NotifierProvider<SelectedStories, List<String>> {
  SelectedStoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedStoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedStoriesHash();

  @$internal
  @override
  SelectedStories create() => SelectedStories();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$selectedStoriesHash() => r'3f63360d64d92f48c6b33bac8b809adc67e21807';

abstract class _$SelectedStories extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
