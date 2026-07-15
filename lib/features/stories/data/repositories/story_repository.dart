import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:narrata/features/stories/domain/models/story.dart';

part 'story_repository.g.dart';

class StoryRepository {
  final FirebaseFirestore _firestore;

  StoryRepository(this._firestore);

  Future<List<Story>> getStories() async {
    final snapshot = await _firestore.collection('stories').get();
    return snapshot.docs
        .map((doc) => Story.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<Story>> getUserSelectedStories(String userId) async {
    // 1. Fetch user stories from subcollection
    final userStoriesSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('user_stories')
        .get();

    final storyIds = userStoriesSnapshot.docs.map((doc) => doc.id).toList();

    // 2. Fetch the actual stories
    // Note: whereIn accepts max 10 elements, so this works for onboarding (7 stories)
    // If users can have more, we'd need to batch this or fetch them individually.
    if (storyIds.length > 10) {
      // Chunking if > 10 stories
      List<Story> allStories = [];
      for (var i = 0; i < storyIds.length; i += 10) {
        final chunk = storyIds.sublist(i, i + 10 > storyIds.length ? storyIds.length : i + 10);
        final snapshot = await _firestore
            .collection('stories')
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        allStories.addAll(snapshot.docs.map((doc) => Story.fromMap(doc.data(), doc.id)));
      }
      return allStories;
    } else {
      final snapshot = await _firestore
          .collection('stories')
          .where(FieldPath.documentId, whereIn: storyIds)
          .get();

      return snapshot.docs
          .map((doc) => Story.fromMap(doc.data(), doc.id))
          .toList();
    }
  }

  Future<void> toggleFavoriteStatus(String userId, String storyId, bool isCurrentlyFavorite) async {
    final storyRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('user_stories')
        .doc(storyId);

    // If the doc doesn't exist, this will create it or update if it exists.
    // We use SetOptions(merge: true) to ensure we don't overwrite progress if it exists.
    await storyRef.set({
      'isFavorite': !isCurrentlyFavorite,
    }, SetOptions(merge: true));
  }

  Stream<bool> watchIsFavorite(String userId, String storyId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('user_stories')
        .doc(storyId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return false;
      return snapshot.data()?['isFavorite'] == true;
    });
  }

  Stream<List<Story>> watchFavoriteStories(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('user_stories')
        .where('isFavorite', isEqualTo: true)
        .snapshots()
        .asyncMap((snapshot) async {
      if (snapshot.docs.isEmpty) return [];

      final storyIds = snapshot.docs.map((doc) => doc.id).toList();

      List<Story> allStories = [];
      for (var i = 0; i < storyIds.length; i += 10) {
        final chunk = storyIds.sublist(i, i + 10 > storyIds.length ? storyIds.length : i + 10);
        final storySnapshot = await _firestore
            .collection('stories')
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        allStories.addAll(storySnapshot.docs.map((doc) => Story.fromMap(doc.data(), doc.id)));
      }
      return allStories;
    });
  }

  Future<List<Story>> getFavoriteStories(String userId) async {
    // 1. Fetch user stories that are favorites
    final userStoriesSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('user_stories')
        .where('isFavorite', isEqualTo: true)
        .get();

    if (userStoriesSnapshot.docs.isEmpty) return [];

    final storyIds = userStoriesSnapshot.docs.map((doc) => doc.id).toList();

    // 2. Fetch the actual stories in chunks of 10
    List<Story> allStories = [];
    for (var i = 0; i < storyIds.length; i += 10) {
      final chunk = storyIds.sublist(i, i + 10 > storyIds.length ? storyIds.length : i + 10);
      final snapshot = await _firestore
          .collection('stories')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      allStories.addAll(snapshot.docs.map((doc) => Story.fromMap(doc.data(), doc.id)));
    }
    return allStories;
  }
}

@riverpod
StoryRepository storyRepository(Ref ref) {
  return StoryRepository(FirebaseFirestore.instance);
}
