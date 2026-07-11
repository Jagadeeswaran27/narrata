class AppUser {
  final String id;
  final String email;
  final String? displayName;

  const AppUser({required this.id, required this.email, this.displayName});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser &&
        other.id == id &&
        other.email == email &&
        other.displayName == displayName;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ displayName.hashCode;
}
