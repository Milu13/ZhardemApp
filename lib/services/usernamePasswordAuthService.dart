
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:zhardem/services/customSnackBar.dart';

import '../screens/homeScreen.dart';


class UsernamePasswordAuthService extends ChangeNotifier{

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading  => _isLoading;

  String? _uid ;
  String get uid => _uid!;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;



  // вход через почту и пароль
  void signInWithEmailAndPassword(BuildContext context, String email, String password)async{
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context)=> HomeScreen(),
        ),
      );
    }
    on FirebaseAuthException catch(e){
      if(e.code =='user-not-found'){
         CustomSnackBar.showSnackBar(context, 'Неправильный email или пароль. Повторите попытку', true);
        return;
      }
      else if(e.code == 'wrong-password'){
        CustomSnackBar.showSnackBar(context, 'Неправильный email или пароль. Повторите попытку', true);
        return;
      }
      else{
        CustomSnackBar.showSnackBar(
          context,
          'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.',
          true,
        );
      }

    }

  }


  // регистрация через почту и пароль
  void createUserWithEmailAndPassword(BuildContext context,String email,String password) async{
    try{
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    }
    on FirebaseAuthException catch(e){
      if(e.code == 'email-alreay-in-use'){
        CustomSnackBar.showSnackBar(context, 'Такой Email уже используется, повторите попытку с использованием другого Email', true);
        return;
      }
      else{
        CustomSnackBar.showSnackBar(context, 'Что - то пошло не так!', true);
        print("wrong pass");
      }
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context)=> const HomeScreen(),
      ),
    );
  }



  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      // Успешная отправка письма для сброса пароля
      final successMessage = 'Письмо для сброса пароля отправлено на $email';
      logger.i(successMessage);
      // Показываем пользователю уведомление об успешной отправке письма
      showSnackBar(context, successMessage, false);
    } catch (error) {
      // Ошибка при отправке письма для сброса пароля
      logger.e(error.toString());
      // Показываем пользователю уведомление об ошибке
      showSnackBar(context, error.toString(), true);
    }
  }


  void checkOldPasswordAndUpdate(BuildContext context, String oldPassword, String newPassword) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final currentUser = auth.currentUser;

    if (currentUser != null) {
      try {
        // Получение email пользователя
        String? email = currentUser.email;

        if (email != null) {
          // Переаутентификация пользователя с использованием email и password
          AuthCredential credential = EmailAuthProvider.credential(email: email, password: oldPassword);
          await auth.currentUser!.reauthenticateWithCredential(credential);

          // Если переаутентификация прошла успешно, обновляем пароль
          await auth.currentUser!.updatePassword(newPassword);
          showSnackBar(context, 'Пароль успешно изменен', false);
        } else {
          showSnackBar(context, 'Не удалось получить email пользователя', true);
        }
      } on FirebaseAuthException catch (error) {
        if (error.code == 'wrong-password') {
          showSnackBar(context, 'Неправильный старый пароль', true);
        } else {
          showSnackBar(context, 'Ошибка при изменении пароля: ${error.message}', true);
        }
      } catch (error) {
        showSnackBar(context, 'Ошибка при изменении пароля: $error', true);
      }
    }
  }



  void showSnackBar(BuildContext context, String message, bool isError) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


}