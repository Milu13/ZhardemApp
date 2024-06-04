import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:zhardem/screens/loginScreen.dart';
import 'package:zhardem/services/customSnackBar.dart';
import 'package:zhardem/services/usernamePasswordAuthService.dart';

import '../widgets/labelText.dart';
import '../widgets/saveElevatedButton.dart';
import '../widgets/usernameTextField.dart';
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  TextEditingController _usernameController = TextEditingController();

  void resetPassword()async{
    try{
      final ap = Provider.of<UsernamePasswordAuthService>(context,listen: false);
      await ap.resetPassword(_usernameController.text.trim(), context);
      logger.i("сообщщение успешно было отправлено");
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> LoginScreen()), (route) => false);
    }
    catch(error){
      CustomSnackBar.showSnackBar(context, "Что-то пошло не так",true);
      logger.i(error.toString());
    }
  }




  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  "assets/logo.png",
                  height: screenHeight * 0.2,
                ),

                SizedBox(height: screenHeight * 0.02),

                const LabelText(text: "Войти"),

                SizedBox(height: screenHeight * 0.02),

                UsernameTextField(
                  usernameController: _usernameController,
                  hint: "username",
                ),

                SaveElevatedButton(
                  height: screenHeight * 0.07,
                  text: 'Сбросить пароль',
                  onPressed: resetPassword,
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }
}
