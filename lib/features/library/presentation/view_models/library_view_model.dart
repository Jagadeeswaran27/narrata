import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:narrata/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:narrata/features/stories/data/repositories/story_repository.dart';
import 'package:narrata/features/stories/domain/models/story.dart';

part 'library_view_model.g.dart';

@riverpod
Future<List<Story>> libraryStories(Ref ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return [];

  final repository = ref.watch(storyRepositoryProvider);
  // Force a refetch/new query instance since we want fresh data for the library.
  return repository.getUserSelectedStories(user.id);
}

@riverpod
class LibrarySelectedGenre extends _$LibrarySelectedGenre {
  @override
  String build() => 'All';

  void setGenre(String genre) {
    state = genre;
  }
}
