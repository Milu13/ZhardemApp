
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:zhardem/screens/homeScreen.dart';
import 'package:zhardem/screens/phoneAuthScreen.dart';
import 'package:zhardem/screens/registerScreen.dart';
import 'package:zhardem/screens/resetPasswordScreen.dart';
import 'package:zhardem/services/customSnackBar.dart';
import 'package:zhardem/services/usernamePasswordAuthService.dart';
import 'package:zhardem/widgets/labelText.dart';
import 'package:zhardem/widgets/passwordTextField.dart';
import 'package:zhardem/widgets/redTextButton.dart';
import 'package:zhardem/widgets/saveElevatedButton.dart';
import 'package:zhardem/widgets/usernameTextField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var logger = Logger(
    printer: PrettyPrinter(),
  );
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login(){
    try{
      final ap = Provider.of<UsernamePasswordAuthService>(context,listen: false);
      ap.signInWithEmailAndPassword(context, _usernameController.text.trim(), _passwordController.text.trim());
      logger.i("$_usernameController and $_passwordController");
    }
    catch(error){
      CustomSnackBar.showSnackBar(context, "Что-то пошло не так!", true);
    }
  }


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;
    final ap = Provider.of<UsernamePasswordAuthService>(context, listen: true);

    return Scaffold(

      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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

                  SizedBox(height: screenHeight * 0.01),

                  PasswordTextField(
                    passwordController: _passwordController,
                    hint: "password",
                    textInputAction: TextInputAction.done,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  SaveElevatedButton(
                    height: screenHeight * 0.07,
                    text: 'Войти',
                    onPressed: login,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: RedTextButton(
                          text: "Зарегистрироваться",
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const RegisterScreen()),
                                  (route) => false,
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 16), // Добавляем промежуток между кнопками
                      Flexible(
                        flex: 1,
                        child: RedTextButton(
                          text: "Забыли пароль",
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
                                  (route) => false,
                            );
                          },
                        ),
                      ),
                    ],
                  ),


                  SizedBox(height: screenHeight * 0.02),

                  const Text("Или"),

                  SizedBox(height: screenHeight * 0.02),

                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PhoneAuthScreen()),
                      );
                    },
                    icon:  Icon(Icons.phone_android, size: screenHeight * 0.05),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
