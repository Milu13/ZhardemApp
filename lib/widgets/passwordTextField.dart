import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController passwordController;
  final String hint;
  final TextInputAction textInputAction;


  const PasswordTextField({
    Key? key,
    required this.passwordController,
    required this.hint,
    required this.textInputAction
  }) : super(key: key);



  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isHiddenPassword = true;
  void togglePass(){
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      controller: widget.passwordController,
      obscureText: isHiddenPassword,
      textInputAction: widget.textInputAction,
      validator: (value) => value != null && value.length < 6
          ? 'Минимум 6 символов'
          : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.blue)
        ),
        hintText: widget.hint,
        suffix: InkWell(
          onTap: togglePass,
          child: Icon(
           isHiddenPassword
                ? Icons.visibility_off
                : Icons.visibility,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
