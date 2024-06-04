import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:zhardem/models/userModel.dart';
import 'package:uuid/uuid.dart';

class UserService extends ChangeNotifier {
  late String name = "";
  late String userPhoneNumber = "";
  late String email = "";
  late String image = "";

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  final Reference _storageReference =
      FirebaseStorage.instance.ref().child('profile_images');

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // добавление пользователя
  Future<void> addUser(Users user, File? imageFile) async {
    try {
      String? photoURL;

      if (imageFile != null) {
        final String uuid = Uuid().v1();
        TaskSnapshot snapshot =
            await _storageReference.child('$uuid.jpg').putFile(imageFile);
        photoURL = await snapshot.ref.getDownloadURL();
      }

      await _usersCollection.doc(user.uid).set({
        'name': user.name,
        'email': user.email,
        'phoneNumber': user.phoneNumber,
        'notificationPreferences': user.notificationPreferences,
        'profilePhotoURL': photoURL ?? user.profilePhotoURL,
      });
    } catch (e) {
      logger.e('Ошибка при добавлении пользователя: $e');
      rethrow;
    }
  }

  // обновление пользователя
  Future<void> updateUser(Users user, File? newImageFile) async {
    try {
      String? newPhotoURL = user.profilePhotoURL;

      if (newImageFile != null) {
        final String uuid = Uuid().v1();
        TaskSnapshot snapshot =
            await _storageReference.child('$uuid.jpg').putFile(newImageFile);
        newPhotoURL = await snapshot.ref.getDownloadURL();
      }

      await _usersCollection.doc(user.uid).update({
        'name': user.name,
        'email': user.email,
        'phoneNumber': user.phoneNumber,
        'notificationPreferences': user.notificationPreferences,
        'profilePhotoURL': newPhotoURL,
      });
    } catch (e) {
      logger.e('Ошибка при обновлении пользователя: $e');

      if (e.toString().contains('Some requested document was not found')) {
        logger.i('Пользователь не найден, вызываем addUser');
        await addUser(user, newImageFile);
      } else {
        rethrow;
      }
    }
  }

  // Удаление пользователя
  Future<void> deleteUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User is not logged in');
      }

      await _firestore.collection('users').doc(user.uid).delete();

      if (user.photoURL != null) {
        await _storage.refFromURL(user.photoURL!).delete();
      }

      await user.delete();
    } catch (error) {
      logger.e("Ошибка при удалении пользователя \n ============ \n $error \n =================");
    }
  }

  Future<void> getUserData() async {
    try {
      String? currentUserUID = FirebaseAuth.instance.currentUser?.uid;

      if (currentUserUID != null) {
        DocumentSnapshot userSnapshot =
            await FirebaseFirestore.instance.collection('users').doc(currentUserUID).get();

        if (userSnapshot.exists) {
          Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

          name = userData['name'] ?? "";
          userPhoneNumber = userData['phoneNumber'] ?? "";
          email = userData['email'] ?? "";
          image = userData['profilePhotoURL'] ?? "";

          logger.i(name);
          logger.i(userPhoneNumber);
          logger.i(email);
        } else {
          print('Данные пользователя не найдены в Firestore');

          name = "";
          userPhoneNumber = "";
          email = "";
          image = "";

          logger.i(name);
          logger.i(userPhoneNumber);
          logger.i(email);
        }
      } else {
        print('Пользователь не вошел в систему');
      }
    } catch (e) {
      print('Ошибка при получении данных пользователя из Firestore: $e');
    }
  }

  Stream<List<Users>> searchUsersStream = Stream.empty();

  void searchUsersByName(String query) {
    searchUsersStream = _usersCollection
        .where('name', isGreaterThanOrEqualTo: query)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Users(
          uid: doc.id,
          name: doc['name'],
          email: doc['email'],
          phoneNumber: doc['phoneNumber'],
          notificationPreferences: doc['notificationPreferences'],
          profilePhotoURL: doc['profilePhotoURL'],
        );
      }).toList();
    });
    notifyListeners();
  }

  Future<List<Users>> getAllUsers() async {
    try {
      QuerySnapshot usersSnapshot = await _usersCollection.get();

      List<Users> allUsers = usersSnapshot.docs.map((doc) {
        return Users(
          uid: doc.id,
          name: doc['name'],
          email: doc['email'],
          phoneNumber: doc['phoneNumber'],
          notificationPreferences: doc['notificationPreferences'],
          profilePhotoURL: doc['profilePhotoURL'],
        );
      }).toList();

      return allUsers;
    } catch (e) {
      logger.e('Ошибка при получении всех пользователей: $e');
      return [];
    }
  }
}
