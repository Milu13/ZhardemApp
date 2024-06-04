import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../models/Contacts.dart';
import '../models/medicalRecordModel.dart';

class MedicalCardService extends ChangeNotifier {
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  final CollectionReference _cardCollection = FirebaseFirestore.instance.collection('medicalCards');

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
  late List<String> allergies;
  late List<String> medications;
  late List<String> conditions;

  Future<void> updateMedicalCard(MedicalRecord data) async {
    try {
      String? currentUserUID = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserUID != null) {
        Map<String, dynamic> updateData = {
          'medicalHistory': data.medicalHistory,
          'allergies': data.allergies,
          'medications': data.medications,
          'conditions': data.conditions,
          'personalData': data.personalData.toJson(),
        };

        updateData.removeWhere((key, value) => value == null || value == '');

        await _cardCollection.doc(currentUserUID).update(updateData);
        logger.i('Данные успешно обновлены!');
      } else {
        logger.e('currentUserUID is null');
      }
    } catch (e) {
      logger.e('Что-то пошло не так при обновлении! \n $e');
      if (e.toString().contains('Some requested document was not found')) {
        logger.i('Документ не найден, вызываем addMedicalCard');
        await addMedicalCard(data);
      } else {
        rethrow;
      }
    }
  }

  Future<void> addMedicalCard(MedicalRecord data) async {
    try {
      String? currentUserUID = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserUID != null) {
        await _cardCollection.doc(currentUserUID).set({
          'medicalHistory': data.medicalHistory,
          'allergies': data.allergies,
          'medications': data.medications,
          'conditions': data.conditions,
          'personalData': data.personalData.toJson(),
        });
        logger.i('Данные успешно отправлены!');
      } else {
        logger.e('currentUserUID is null');
      }
    } catch (e) {
      logger.e('Что-то пошло не так! \n $e');
    }
  }

  Future<void> getMedicalRecord() async {
    try {
      String? currentUserUID = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserUID != null) {
        DocumentSnapshot docSnapshot = await _cardCollection.doc(currentUserUID).get();
        if (docSnapshot.exists) {
          var data = docSnapshot.data() as Map<String, dynamic>;
          var personalData = data['personalData'] as Map<String, dynamic>;

          fullName = personalData['fullName'];
          iin = personalData['iin'];
          birthDate = personalData['birthDate'];
          gender = personalData['gender'];
          nationality = personalData['nationality'];
          citizenship = personalData['citizenship'];
          address = personalData['address'];
          familyStatus = personalData['familyStatus'];
          emergencyContacts = (personalData['emergencyContacts'] as List<dynamic>)
              .map((contact) => Contacts.fromJson(contact))
              .toList();
          medicalHistory = List<String>.from(data['medicalHistory']);
          allergies = List<String>.from(data['allergies']);
          medications = List<String>.from(data['medications']);
          conditions = List<String>.from(data['conditions']);
        } else {
          logger.i('Документ не найден!');
        }
      } else {
        logger.e('currentUserUID is null');
      }
    } catch (e) {
      logger.e('Что-то пошло не так при получении данных! \n $e');
    }
  }

  // Добавляем методы getContacts и deleteMedicalCardByIIN

  Future<List<Contacts>> getContacts() async {
    try {
      String? currentUserUID = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserUID != null) {
        DocumentSnapshot docSnapshot = await _cardCollection.doc(currentUserUID).get();
        if (docSnapshot.exists) {
          var data = docSnapshot.data() as Map<String, dynamic>;
          var personalData = data['personalData'] as Map<String, dynamic>;
          List<Contacts> contacts = (personalData['emergencyContacts'] as List<dynamic>)
              .map((contact) => Contacts.fromJson(contact))
              .toList();
          return contacts;
        } else {
          logger.i('Документ не найден!');
          return [];
        }
      } else {
        logger.e('currentUserUID is null');
        return [];
      }
    } catch (e) {
      logger.e('Что-то пошло не так при получении контактов! \n $e');
      return [];
    }
  }

  Future<void> deleteMedicalCardByIIN(String iin) async {
    try {
      QuerySnapshot querySnapshot = await _cardCollection.where('personalData.iin', isEqualTo: iin).get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      logger.i('Медицинская карта успешно удалена!');
    } catch (e) {
      logger.e('Что-то пошло не так при удалении медицинской карты! \n $e');
    }
  }
}
