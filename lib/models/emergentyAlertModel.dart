class EmergencyAlert {
  late String alertId;
  late String senderUid;
  late DateTime timestamp;
  late String alertType;
  late String location;
  late String emergencyMessage;

  EmergencyAlert({
    required this.alertId,
    required this.senderUid,
    required this.timestamp,
    required this.alertType,
    required this.location,
    required this.emergencyMessage,
  });
}
