import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:zhardem/screens/verifyOtpScreen.dart';
import 'package:zhardem/services/customSnackBar.dart';

class PhoneNumberAuthService extends ChangeNotifier{

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

  //вход через номер телефона
  void signInWithPhoneNumber(BuildContext context,String phoneNumber) async{
    try{
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async{
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (FirebaseAuthException error){
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context)=> VerifyOtpScreen(verificationId: verificationId,),
              ),
            );
          },
          codeAutoRetrievalTimeout: (verificationId){}
      );
    }
    on FirebaseAuthException catch(e){
      CustomSnackBar.showSnackBar(context, e.message.toString(),true);

    }
  }
  // верификация по номеру телефона
  void verifyOtp({
    required BuildContext context,
    required String userOtp,
    required String verificationId,
    required Function onSuccess
  })async{
    _isLoading =true;
    notifyListeners();
    try{
      PhoneAuthCredential creds = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: userOtp);
      User? user = (await _firebaseAuth.signInWithCredential(creds)).user!;
      if(user != null){
        _uid = user.uid;
        onSuccess();
      }
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch(e){
      CustomSnackBar.showSnackBar(context, e.message.toString(),true);
      _isLoading = false;
      notifyListeners();
    }
  }
}