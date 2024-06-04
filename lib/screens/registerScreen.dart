import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:zhardem/screens/phoneAuthScreen.dart';
import 'package:zhardem/services/customSnackBar.dart';
import 'package:zhardem/services/usernamePasswordAuthService.dart';
import 'package:zhardem/widgets/labelText.dart';
import 'package:zhardem/widgets/passwordTextField.dart';
import 'package:zhardem/widgets/redTextButton.dart';
import 'package:zhardem/widgets/usernameTextField.dart';
import 'package:zhardem/screens/loginScreen.dart';
import '../widgets/saveElevatedButton.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();


  @override
  void initState() {

  }




  void register()
  {
    try{
      final ap = Provider.of<UsernamePasswordAuthService>(context,listen: false);
      if(_passwordController.text.trim() == _repeatPasswordController.text.trim()){
        ap.createUserWithEmailAndPassword(context, _usernameController.text.trim(), _passwordController.text.trim());
        logger.i("$_usernameController and $_passwordController");
      }
      else{
        CustomSnackBar.showSnackBar(context, "Пароли не совподают", true);
        logger.e("Пароли не совпадают $_usernameController pass => $_passwordController rePass=> $_repeatPasswordController");
      }
    }
    catch(error){
      logger.e(error.toString());
      CustomSnackBar.showSnackBar(context, error.toString(), true);
    }
  }
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.1, horizontal: screenWidth * 0.05),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Используйте spaceEvenly для равномерного распределения между элементами
            children: [
              const LabelText(text: "Регистрация"),
              SizedBox(height: screenHeight * 0.02), // Пространство между виджетами
              UsernameTextField(usernameController: _usernameController, hint: "имя пользователя"),
              SizedBox(height: screenHeight * 0.02), // Пространство между виджетами
              PasswordTextField(passwordController: _passwordController, hint: "придумайте пароль", textInputAction: TextInputAction.next),
              SizedBox(height: screenHeight * 0.02), // Пространство между виджетами
              PasswordTextField(passwordController: _repeatPasswordController, hint: "повторите пароль", textInputAction: TextInputAction.done),
              SizedBox(height: screenHeight * 0.02), // Пространство между виджетами
              SaveElevatedButton(
                height: screenHeight * 0.06,
                text: 'Зарегистрироваться',
                onPressed: register,
              ),
              SizedBox(height: screenHeight * 0.02), // Пространство между виджетами
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("уже есть аккаунт? "),
                  RedTextButton(
                    text: "Войти",
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                    },
                  ),
                ],
              ),
              const Text("Или"),
              SizedBox(height: screenHeight * 0.02), // Пространство между виджетами
              IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const PhoneAuthScreen()), (route) => false);
                },
                icon: const Icon(Icons.phone_android, size: 60),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
