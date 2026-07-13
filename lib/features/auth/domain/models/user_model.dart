enum AuthMethod { google, phone, email }

class UserModel {
  final String uid;
  final String fullName;
  final String? email;
  final String? phone;
  final AuthMethod authMethod;
  final int credits;
  final DateTime? createdAt;
  final bool isOnboardingCompleted;

  const UserModel({
    required this.uid,
    required this.fullName,
    this.email,
    this.phone,
    required this.authMethod,
    this.credits = 3,
    this.createdAt,
    this.isOnboardingCompleted = false,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      uid: id,
      fullName: map['fullName'] ?? '',
      email: map['email'],
      phone: map['phone'],
      authMethod: AuthMethod.values.firstWhere(
        (e) => e.name == map['authMethod'],
        orElse: () => AuthMethod.phone,
      ),
      credits: map['credits']?.toInt() ?? 3,
      isOnboardingCompleted: map['isOnboardingCompleted'] ?? false,
      createdAt: map['createdAt'] != null
          ? (map['createdAt']).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      'authMethod': authMethod.name,
      'credits': credits,
      'isOnboardingCompleted': isOnboardingCompleted,
    };
  }
}
