import "package:email_validator/email_validator.dart";
import "package:flutter/material.dart";
class UsernameTextField extends StatelessWidget {
  const UsernameTextField({
    Key? key,
    required this.usernameController,
    required this.hint,
  }) : super(key: key);

  final TextEditingController usernameController;
  final String hint;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: usernameController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      validator: (email) =>
      email != null && !EmailValidator.validate(email)
          ? 'Введите правильный Email'
          : null,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        hintText: hint,
      ),
    );
  }
}