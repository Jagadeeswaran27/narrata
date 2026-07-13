// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userStories)
final userStoriesProvider = UserStoriesProvider._();

final class UserStoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Story>>,
          List<Story>,
          FutureOr<List<Story>>
        >
    with $FutureModifier<List<Story>>, $FutureProvider<List<Story>> {
  UserStoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userStoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userStoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<Story>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Story>> create(Ref ref) {
    return userStories(ref);
  }
}

String _$userStoriesHash() => r'a8ba1a34b00c2f439507a78268cd57846dff558a';

@ProviderFor(SelectedGenre)
final selectedGenreProvider = SelectedGenreProvider._();

final class SelectedGenreProvider
    extends $NotifierProvider<SelectedGenre, String> {
  SelectedGenreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedGenreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedGenreHash();

  @$internal
  @override
  SelectedGenre create() => SelectedGenre();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$selectedGenreHash() => r'a6704a28c09df78d53b1140e77a56ed5453a5f08';

abstract class _$SelectedGenre extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
