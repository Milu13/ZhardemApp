import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

import '../models/placeModel.dart';

class PlaceService extends ChangeNotifier {

  var logger = Logger(
    printer: PrettyPrinter()
  );

  final CollectionReference _placesCollection =
  FirebaseFirestore.instance.collection('places');

  // Создание нового места
  Future<void> addPlace(PlaceModel place) async {
    try {
      await _placesCollection.doc(place.id).set({
        'name': place.name,
        'description': place.description,
        'imageUrl': place.imageUrl,
        'locationLat': place.locationLat,
        'locationLng': place.locationLng,
      });

      logger.i('Место успешно добавлено!');
    } catch (e) {
      logger.e("Что-то пошло не так при добавлении места!  $e");
    }
  }

  // Получение списка всех мест
  Future<List<PlaceModel>> getAllPlaces() async {
    try {
      QuerySnapshot placesSnapshot = await _placesCollection.get();
      return placesSnapshot.docs
          .map((doc) => PlaceModel(
        doc.id,
        doc['name'],
        doc['description'],
        List<String>.from(doc['imageUrl']),
        doc['locationLat'],
        doc['locationLng'],
      ))
          .toList();

     //logger.i("Данные успешно получены! метод getAllPlaces");
    } catch (e) {

      logger.e("Что-то пошло не так при получении списка мест: $e");
      return [];
    }
  }

  // Получение информации о конкретном месте по ID
  Future<PlaceModel?> getPlaceById(String placeId) async {
    try {
      DocumentSnapshot placeSnapshot =
      await _placesCollection.doc(placeId).get();

      if (placeSnapshot.exists) {
        return PlaceModel(
          placeSnapshot.id,
          placeSnapshot['name'],
          placeSnapshot['description'],
          List<String>.from(placeSnapshot['imageUrl']),
          placeSnapshot['locationLat'],
          placeSnapshot['locationLng'],
        );
      } else {
        print('Место с ID $placeId не найдено.');
        return null;
      }
    } catch (e) {
      print('Что-то пошло не так при получении места: $e');
      return null;
    }
  }

  // Обновление информации о месте
  Future<void> updatePlace(PlaceModel updatedPlace) async {
    try {
      await _placesCollection.doc(updatedPlace.id).update({
        'name': updatedPlace.name,
        'description': updatedPlace.description,
        'imageUrl': updatedPlace.imageUrl,
        'locationLat': updatedPlace.locationLat,
        'locationLng': updatedPlace.locationLng,
      });

      logger.i('Информация о месте успешно обновлена!');
    } catch (e) {

      logger.e('Что-то пошло не так при обновлении места: $e');
    }
  }

  // Удаление места
  Future<void> deletePlace(String placeId) async {
    try {
      await _placesCollection.doc(placeId).delete();

      logger.i('Место успешно удалено!');
    } catch (e) {

      logger.e('Что-то пошло не так при удалении места: $e');
    }
  }


}