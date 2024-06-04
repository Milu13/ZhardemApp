import 'package:zhardem/models/personalDataModel.dart';

class MedicalRecord {
  late List<String> medicalHistory;
  late List<String> allergies;
  late List<String> medications;
  late List<String> conditions;
  late PersonalDataModel personalData;

  MedicalRecord({
    List<String>? medicalHistory,
    List<String>? allergies,
    List<String>? medications,
    required this.personalData,
    List<String>? conditions,
  })  : allergies = allergies ?? [],
        conditions = conditions ?? [],
        medicalHistory = medicalHistory ?? [],
        medications = medications ?? [];

  void addCondition(String value) {
    conditions.add(value);
  }

  void addAllergy(String value) {
    allergies.add(value);
  }

  void addMedicalHistory(String value) {
    medicalHistory.add(value);
  }

  void addMedications(String value) {
    medications.add(value);
  }

  void removeCondition(String value) {
    conditions.remove(value);
  }

  void removeAllergy(String value) {
    allergies.remove(value);
  }

  void removeMedicalHistory(String value) {
    medicalHistory.remove(value);
  }

  void removeMedications(String value) {
    medications.remove(value);
  }
}
