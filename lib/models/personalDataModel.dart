import 'Contacts.dart';

class PersonalDataModel {
  late String fullName;
  late String iin;
  late String birthDate;
  late String gender;
  late String nationality;
  late String citizenship;
  late String address;
  late String familyStatus;
  late List<Contacts> emergencyContacts;
  late List<String> medicalHistory;

  PersonalDataModel({
    required this.fullName,
    required this.iin,
    required this.birthDate,
    required this.gender,
    required this.nationality,
    required this.citizenship,
    required this.address,
    required this.familyStatus,
    required this.emergencyContacts,
    required this.medicalHistory,
  });

  factory PersonalDataModel.fromJson(Map<String, dynamic> json) {
    return PersonalDataModel(
      fullName: json["fullName"] ?? "",
      iin: json["iin"] ?? "",
      birthDate: json["birthDate"] ?? "",
      gender: json["gender"] ?? "",
      nationality: json["nationality"] ?? "",
      citizenship: json["citizenship"] ?? "",
      address: json["address"] ?? "",
      familyStatus: json["familyStatus"] ?? "",
      emergencyContacts: (json["emergencyContacts"] as List<dynamic>?)
          ?.map((contact) => Contacts.fromJson(contact))
          .toList() ??
          [],
      medicalHistory: List<String>.from(json["medicalHistory"] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "iin": iin,
      "birthDate": birthDate,
      "gender": gender,
      "nationality": nationality,
      "citizenship": citizenship,
      "address": address,
      "familyStatus": familyStatus,
      "emergencyContacts": emergencyContacts.map((contact) => contact.toJson()).toList(),
      "medicalHistory": medicalHistory,
    };
  }
}
