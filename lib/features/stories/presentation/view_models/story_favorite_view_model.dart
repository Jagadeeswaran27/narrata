import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:narrata/features/stories/data/repositories/story_repository.dart';

part 'story_favorite_view_model.g.dart';

@riverpod
Stream<bool> storyFavoriteStatus(Ref ref, String storyId) {
  final repository = ref.watch(storyRepositoryProvider);
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return Stream.value(false);
  }

  return repository.watchIsFavorite(user.uid, storyId);
}

@Riverpod(keepAlive: true)
class StoryFavoriteAction extends _$StoryFavoriteAction {
  @override
  FutureOr<void> build() {}

  Future<void> toggleFavorite(String storyId, bool isCurrentlyFavorite) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final repository = ref.read(storyRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repository.toggleFavoriteStatus(
        user.uid,
        storyId,
        isCurrentlyFavorite,
      );
    });
  }
}
