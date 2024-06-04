import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:zhardem/screens/loginScreen.dart';

import 'package:zhardem/services/phoneNumberAuthService.dart';
import '../widgets/labelText.dart';
import '../widgets/phoneNumberTextField.dart';
import '../widgets/saveElevatedButton.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  var logger = Logger(
    printer: PrettyPrinter(),
  );
  TextEditingController phoneNumberController = TextEditingController();

  void phoneNumberAuth(){
    try{
      final ap = Provider.of<PhoneNumberAuthService>(context, listen: false);
      String phoneNumber = "+7" + phoneNumberController.text.trim();
      ap.signInWithPhoneNumber(context, phoneNumber); // Используйте phoneNumber
      logger.t("phone number $phoneNumber"); // Выведите phoneNumber вместо phoneNumberController
    }
    catch(error){
      logger.e(error.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;
    final double verticalSpace = screenHeight * 0.05; // Расстояние между виджетами

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05,vertical: screenHeight * 0.1),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  "assets/logo.png",
                  height: screenHeight * 0.2,
                ),

                const LabelText(text: "Войти"),

                SizedBox(height: verticalSpace), // Пространство между виджетами

                PhoneNumberTextField(phoneNumberController: phoneNumberController),

                SizedBox(height: verticalSpace), // Пространство между виджетами

                SaveElevatedButton(
                  height: screenHeight * 0.06,
                  text: 'Войти',
                  onPressed: phoneNumberAuth,
                ),

                SizedBox(height: verticalSpace), // Пространство между виджетами

                const Text("Или"),

                SizedBox(height: verticalSpace), // Пространство между виджетами

                IconButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                  },
                  icon: Icon(Icons.supervised_user_circle_outlined, size: screenHeight * 0.05),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
