// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FavoritesViewModel)
final favoritesViewModelProvider = FavoritesViewModelProvider._();

final class FavoritesViewModelProvider
    extends $StreamNotifierProvider<FavoritesViewModel, List<Story>> {
  FavoritesViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritesViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoritesViewModelHash();

  @$internal
  @override
  FavoritesViewModel create() => FavoritesViewModel();
}

String _$favoritesViewModelHash() =>
    r'be93314e48a5f261915d538da8b7dd098b864140';

abstract class _$FavoritesViewModel extends $StreamNotifier<List<Story>> {
  Stream<List<Story>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Story>>, List<Story>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Story>>, List<Story>>,
              AsyncValue<List<Story>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(FavoritesSelectedGenre)
final favoritesSelectedGenreProvider = FavoritesSelectedGenreProvider._();

final class FavoritesSelectedGenreProvider
    extends $NotifierProvider<FavoritesSelectedGenre, String> {
  FavoritesSelectedGenreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritesSelectedGenreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoritesSelectedGenreHash();

  @$internal
  @override
  FavoritesSelectedGenre create() => FavoritesSelectedGenre();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$favoritesSelectedGenreHash() =>
    r'4e247f37833fcd5e5b477f4b3dd6794cc99aa3c4';

abstract class _$FavoritesSelectedGenre extends $Notifier<String> {
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
