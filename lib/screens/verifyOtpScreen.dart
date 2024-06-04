import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:zhardem/screens/homeScreen.dart';
import 'package:zhardem/services/phoneNumberAuthService.dart';
import 'package:zhardem/widgets/saveElevatedButton.dart';
import '../widgets/labelText.dart';
import '../widgets/pinputTextField.dart';
import '../widgets/timerActionButton.dart';
import 'loginScreen.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String verificationId;
   VerifyOtpScreen({required this.verificationId});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  var logger = Logger(
    printer: PrettyPrinter(),
  );


  TextEditingController otpController = TextEditingController();


  void verify(){
    try{
      final ap = Provider.of<PhoneNumberAuthService>(context,listen: false);
      ap.verifyOtp(context: context, userOtp: otpController.text.trim(), verificationId: widget.verificationId, onSuccess: (){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const HomeScreen()), (route) => false);
      });
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
    final double verticalSpace = screenHeight * 0.02; // Расстояние между виджетами

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  "assets/logo.png",
                  height: screenHeight * 0.2,
                ),

                const LabelText(text: "Верификация"),

                PinputTextField(otpController: otpController, lenght: 6),

                SizedBox(height: verticalSpace), // Пространство между виджетами

                SaveElevatedButton(
                  height: screenHeight * 0.06,
                  text: "Войти",
                  onPressed: verify,
                ),

                SizedBox(height: verticalSpace), // Пространство между виджетами

                TimerActionButton(initialSeconds: 30, onButtonPressed: () {}),

                SizedBox(height: verticalSpace), // Пространство между виджетами

                const Text("Или"),

                SizedBox(height: verticalSpace), // Пространство между виджетами

                IconButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                  },
                  icon: const Icon(Icons.supervised_user_circle_outlined, size: 60),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
