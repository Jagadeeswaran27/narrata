import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:narrata/features/auth/domain/models/user_model.dart';
import 'package:narrata/features/auth/presentation/view_models/auth_view_model.dart';

part 'current_user_provider.g.dart';

@riverpod
Stream<UserModel?> currentUser(Ref ref) {
  final authUser = ref.watch(authStateProvider).value;

  if (authUser == null) {
    return Stream.value(null);
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(authUser.id)
      .snapshots()
      .map((doc) {
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  });
}
