import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:zhardem/services/customSnackBar.dart';


Future<File?> pickImage(BuildContext context)async{

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  File? image;
  try{
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedImage != null){
      image =  File(pickedImage.path);
    }
  }catch(e){
    CustomSnackBar.showSnackBar(context, e.toString(), true);
    logger.e(e);
  }
  return image;
}