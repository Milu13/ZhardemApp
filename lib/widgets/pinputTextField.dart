import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
class PinputTextField extends StatelessWidget {
  const PinputTextField({
    super.key,
    required this.otpController,
    required this.lenght
  });

  final TextEditingController otpController;
  final int lenght;

  @override
  Widget build(BuildContext context) {
    return Pinput(
      controller: otpController,
      length: lenght,
      showCursor: true,
      defaultPinTheme: PinTheme(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey,
            )
        ),
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}