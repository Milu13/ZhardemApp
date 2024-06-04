class Contacts {
  late String contactName;
  late String phoneNumber;
  late String emailAddress;

  Contacts({
    required this.contactName,
    required this.phoneNumber,
    required this.emailAddress,
  });

  factory Contacts.fromJson(Map<String, dynamic> json) {
    return Contacts(
      contactName: json["contactName"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      emailAddress: json["emailAddress"] ?? "",
    );
  }

  // Add toJson method for serialization
  Map<String, dynamic> toJson() {
    return {
      "contactName": contactName,
      "phoneNumber": phoneNumber,
      "emailAddress": emailAddress,
    };
  }
}
