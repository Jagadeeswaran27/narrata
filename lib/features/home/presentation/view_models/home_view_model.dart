import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:narrata/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:narrata/features/stories/data/repositories/story_repository.dart';
import 'package:narrata/features/stories/domain/models/story.dart';

part 'home_view_model.g.dart';

@riverpod
Future<List<Story>> userStories(Ref ref) async {
  final user = await ref.watch(authStateProvider.future);
  if (user == null) {
    return [];
  }
  
  final repository = ref.watch(storyRepositoryProvider);
  return repository.getUserSelectedStories(user.id);
}

@riverpod
class SelectedGenre extends _$SelectedGenre {
  @override
  String build() => 'All';

  void setGenre(String genre) {
    state = genre;
  }
}
