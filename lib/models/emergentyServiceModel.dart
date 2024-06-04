class EmergencyService {
  late String serviceId;
  late String serviceType;
  late String serviceName;
  late double latitude;
  late double longitude;
  late String address;
  late String contactInfo;

  EmergencyService({
    required this.serviceId,
    required this.serviceType,
    required this.serviceName,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.contactInfo,
  });
}