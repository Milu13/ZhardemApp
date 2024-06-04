class Users {
  late String uid;
  late String name;
  late String email;
  late String phoneNumber;
  late String notificationPreferences;
  String? profilePhotoURL;

  Users({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.notificationPreferences,
    this.profilePhotoURL,
  });
}
