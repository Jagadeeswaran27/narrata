import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:narrata/features/stories/data/repositories/story_repository.dart';
import 'package:narrata/features/stories/domain/models/story.dart';

part 'favorites_view_model.g.dart';

@riverpod
class FavoritesViewModel extends _$FavoritesViewModel {
  @override
  Stream<List<Story>> build() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value([]);

    final repository = ref.watch(storyRepositoryProvider);
    return repository.watchFavoriteStories(user.uid);
  }

}

@riverpod
class FavoritesSelectedGenre extends _$FavoritesSelectedGenre {
  @override
  String build() {
    return 'All';
  }

  void setGenre(String genre) {
    state = genre;
  }
}
