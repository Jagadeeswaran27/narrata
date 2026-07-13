import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:narrata/features/stories/data/repositories/story_repository.dart';
import 'package:narrata/features/stories/domain/models/story.dart';

part 'story_selection_view_model.g.dart';

@riverpod
Future<List<Story>> storiesList(Ref ref) async {
  final repository = ref.watch(storyRepositoryProvider);
  return repository.getStories();
}

@riverpod
class SelectedStories extends _$SelectedStories {
  @override
  List<String> build() {
    return [];
  }

  void toggleStory(String storyId) {
    if (state.contains(storyId)) {
      state = state.where((id) => id != storyId).toList();
    } else {
      if (state.length < 7) {
        state = [...state, storyId];
      }
    }
  }

  Future<void> completeOnboarding() async {
    if (state.length != 7) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final db = FirebaseFirestore.instance;
      final batch = db.batch();

      // 1. Mark onboarding as completed on the user doc
      final userRef = db.collection('users').doc(user.uid);
      batch.update(userRef, {
        'isOnboardingCompleted': true,
      });

      // 2. Create docs in user_stories subcollection
      for (final storyId in state) {
        final storyRef = userRef.collection('user_stories').doc(storyId);
        batch.set(storyRef, {
          'id': storyId,
          'isFavorite': false,
          'isDownloaded': false,
          'progress': {},
        });
      }

      await batch.commit();
    }
  }
}
