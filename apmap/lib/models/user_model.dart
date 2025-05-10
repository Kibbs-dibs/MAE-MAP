enum UserRole { student, teacher, admin }

class UserModel {
  final String email;
  final UserRole role;

  UserModel({required this.email, required this.role});
}
