
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class PhoneNumberTextField extends StatefulWidget {
  const PhoneNumberTextField({
    super.key,
    required this.phoneNumberController,
  });

  final TextEditingController phoneNumberController;



  @override
  State<PhoneNumberTextField> createState() => _PhoneNumberTextFieldState();
}

class _PhoneNumberTextFieldState extends State<PhoneNumberTextField> {

  Country country = Country(
      phoneCode: "+7",
      countryCode: "KZ",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "Kazakhstan",
      example: "Kazakhstan",
      displayName: "Kazakhstan",
      displayNameNoCountryCode: "KZ",
      e164Key: "");

  void selectCountry(){
    showCountryPicker(
        context: context,
        onSelect: (value){
          setState(() {
            value = country;
          });
        });
  }

  String getPhoneNumber(){
    return country.phoneCode + widget.phoneNumberController.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(

      controller: widget.phoneNumberController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "Введите номер телефона",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        prefixIcon: Container(
          margin: EdgeInsets.all(13),
          child: InkWell(
            onTap: (){
              showCountryPicker(
                  context: context,
                  onSelect: (value){
                    setState(() {
                      country= value;
                    });
                  });
            },
            child:  Text("${country.flagEmoji} ${country.phoneCode}",style: const TextStyle(fontSize: 16),),
          ),

        ),
      ),

    );
  }
}
