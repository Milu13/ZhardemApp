class UserLocation {
  late String locationId;
  late String userUid;
  late double latitude;
  late double longitude;
  late DateTime lastUpdate;

  UserLocation({
    required this.locationId,
    required this.userUid,
    required this.latitude,
    required this.longitude,
    required this.lastUpdate,
  });
}
