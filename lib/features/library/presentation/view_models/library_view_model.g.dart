// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(libraryStories)
final libraryStoriesProvider = LibraryStoriesProvider._();

final class LibraryStoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Story>>,
          List<Story>,
          FutureOr<List<Story>>
        >
    with $FutureModifier<List<Story>>, $FutureProvider<List<Story>> {
  LibraryStoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'libraryStoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryStoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<Story>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Story>> create(Ref ref) {
    return libraryStories(ref);
  }
}

String _$libraryStoriesHash() => r'bdf6f7856cac8e4af1a1afde44288bf6c6a397f3';

@ProviderFor(LibrarySelectedGenre)
final librarySelectedGenreProvider = LibrarySelectedGenreProvider._();

final class LibrarySelectedGenreProvider
    extends $NotifierProvider<LibrarySelectedGenre, String> {
  LibrarySelectedGenreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'librarySelectedGenreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$librarySelectedGenreHash();

  @$internal
  @override
  LibrarySelectedGenre create() => LibrarySelectedGenre();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$librarySelectedGenreHash() =>
    r'9df2c4efe6f94cc137ffdd7b2009deaa34a990f7';

abstract class _$LibrarySelectedGenre extends $Notifier<String> {
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
