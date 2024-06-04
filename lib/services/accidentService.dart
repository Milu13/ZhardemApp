import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:zhardem/models/accident.dart';
import 'package:zhardem/models/step.dart';
import 'package:zhardem/services/customSnackBar.dart';

class AccidentService extends ChangeNotifier {
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  final CollectionReference _accidentsCollection =
      FirebaseFirestore.instance.collection('accidents');

  final Reference _storageReference =
      FirebaseStorage.instance.ref().child('accident_images');

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // КРУД операции: get, add, update, delete
  Future<void> addAccident(BuildContext context, Accident accident, File? imageFile) async {
    try {
      String? photoURL;

      if (imageFile != null) {
        final String uuid = Uuid().v1();
        TaskSnapshot snapshot = await _storageReference.child('$uuid.jpg').putFile(imageFile);
        photoURL = await snapshot.ref.getDownloadURL();
      } else {
        photoURL = null;
      }

      List<Map<String, String>> stepsData = [];
      accident.steps.forEach((step) {
        stepsData.add({
          'stepsTitle': step.stepsTitle,
          'title': step.title,
          'description': step.description,
        });
      });

      await _accidentsCollection.doc().set({
        'title': accident.title,
        'page_title': accident.pageTitle,
        'description': accident.description,
        'photo_url': photoURL,
        'steps': stepsData,
      });
      logger.i("Успех!");
      CustomSnackBar.showSnackBar(context, 'Данные успешно загружены', false);
      Navigator.pop(context);
    } catch (e) {
      logger.e("Что-то пошло не так! $e");
      CustomSnackBar.showSnackBar(context, 'Упс, ошибка! $e', true);
    }
  }

  Future<List<Accident>> getAllAccidents() async {
    try {
      QuerySnapshot snapshot = await _accidentsCollection.get();

      List<Accident> accidents = snapshot.docs.map((doc) {
        List<Steps> steps = [];
        List<dynamic> stepsData = doc['steps'];
        stepsData.forEach((step) {
          steps.add(Steps(
            stepsTitle: step['stepsTitle'],
            title: step['title'],
            description: step['description'],
          ));
        });

        return Accident(
          title: doc['title'],
          pageTitle: doc['page_title'],
          photoUrl: doc['photo_url'],
          description: doc['description'],
          steps: steps,
        );
      }).toList();

      for (var item in accidents) {
        logger.i("${item.title}");
        logger.i("${item.pageTitle}");
        logger.i("${item.description}");
        logger.i("${item.photoUrl}");
        for (var step in item.steps) {
          logger.i(step.title);
          logger.i(step.stepsTitle);
          logger.i(step.description);
        }
      }
      return accidents;
    } catch (e) {
      logger.e("Не удалось загрузить данные: $e");
      return [];
    }
  }

  Future<void> updateAccident(Accident accident, File? newImageFile) async {
    try {
      String? newPhotoURL = accident.photoUrl;

      if (newImageFile != null) {
        final String uuid = Uuid().v1();
        TaskSnapshot snapshot = await _storageReference.child('$uuid.jpg').putFile(newImageFile);
        newPhotoURL = await snapshot.ref.getDownloadURL();
      }

      List<Map<String, String>> stepsData = [];
      accident.steps.forEach((step) {
        stepsData.add({
          'stepsTitle': step.stepsTitle,
          'title': step.title,
          'description': step.description,
        });
      });

      await _accidentsCollection.doc(accident.title).update({
        'title': accident.title,
        'page_title': accident.pageTitle,
        'description': accident.description,
        'photo_url': newPhotoURL,
        'steps': stepsData,
      });

      logger.i("Данные успешно обновились");
    } catch (e) {
      logger.e("Что-то пошло не так! $e");
    }
  }

  Future<void> deleteAccident(Accident accident) async {
    try {
      // Удаляем документ из коллекции 'accidents' по его заголовку
      await _firestore.collection('accidents').doc(accident.title).delete();

      // Удаляем фотографию пользователя, если она существует
      if (accident.photoUrl != null) {
        await _storage.refFromURL(accident.photoUrl!).delete();
      }
      logger.i("Данные успешно удалены");
    } catch (e) {
      logger.e("Что-то пошло не так! $e");
    }
  }
}
