import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:zhardem/models/userModel.dart';
import 'package:zhardem/services/customSnackBar.dart';
import 'package:zhardem/services/userService.dart';
import 'package:zhardem/widgets/phoneNumberTextField.dart';
import 'package:zhardem/widgets/saveElevatedButton.dart';
import 'package:zhardem/widgets/usernameTextField.dart';
import '../services/imageService.dart';
import 'package:http/http.dart' as http;

class ProfileEditScreen extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _notificationController = TextEditingController();
  File? image;
  String? photoURL;

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  // select image
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initUserData();
  }

  void initUserData() async {
    final userService = Provider.of<UserService>(context, listen: false);
    await userService.getUserData();

    if (userService.name.isNotEmpty &&
        userService.userPhoneNumber.isNotEmpty &&
        userService.email.isNotEmpty) {
      setState(() {
        _nameController.text = userService.name;
        _phoneController.text = userService.userPhoneNumber;
        _emailController.text = userService.email;
        photoURL = userService.image;
      });
    } else {
      CustomSnackBar.showSnackBar(context, "Не удалось получить данные пользователя", true);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notificationController.dispose();
    super.dispose();
  }

  void updateProfile() {
    try {
      final ap = Provider.of<UserService>(context, listen: false);
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String name = _nameController.text.trim();
      String email = _emailController.text.trim();
      String phoneNumber = _phoneController.text.trim();
      String notificationPreferences = _notificationController.text.trim();

      Users user = Users(
        uid: uid,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        notificationPreferences: notificationPreferences,
      );

      ap.updateUser(user, image);
      CustomSnackBar.showSnackBar(context, "Данные успешно сохранены!", false);
      logger.i("${name + email + phoneNumber + notificationPreferences}");
    } catch (error) {
      logger.e(error);
      CustomSnackBar.showSnackBar(context, "что-то пошло не так!", true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактировать профиль'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => selectImage(),
                child: photoURL == null
                    ? const CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 70,
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(photoURL!),
                        radius: 70,
                      ),
              ),
              SizedBox(height: screenHeight * 0.02),
              UsernameTextField(usernameController: _nameController, hint: 'Имя'),
              SizedBox(height: screenHeight * 0.02),
              UsernameTextField(usernameController: _emailController, hint: 'Почта'),
              SizedBox(height: screenHeight * 0.02),
              PhoneNumberTextField(phoneNumberController: _phoneController),
              SizedBox(height: screenHeight * 0.02),
              SaveElevatedButton(height: 50, text: 'Сохранить изменения', onPressed: updateProfile),
            ],
          ),
        ),
      ),
    );
  }
}
