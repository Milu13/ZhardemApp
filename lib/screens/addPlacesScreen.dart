import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:provider/provider.dart';
import 'package:zhardem/widgets/saveElevatedButton.dart';
import '../models/placeModel.dart';
import '../services/placeService.dart';


class AddPlacesScreen extends StatefulWidget {
  const AddPlacesScreen({Key? key}) : super(key: key);

  @override
  _AddPlacesScreenState createState() => _AddPlacesScreenState();
}

class _AddPlacesScreenState extends State<AddPlacesScreen> {

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _location_lat = TextEditingController();
  final TextEditingController _location_lng = TextEditingController();

  List<ImageFile> images = <ImageFile>[];
  LatLng? _selectedLatLng;


  final controller = MultiImagePickerController(
    maxImages: 10, // максимальное количество изображений, которые можно выбрать
    withReadStream: true, // указываем, что нам нужны данные в виде байтов (stream)
    allowedImageTypes: ['png', 'jpg', 'jpeg'], // указываем разрешенные форматы изображений
  );


  final PlaceService placeService = PlaceService();

  Future<void> addPlace() async {
    try{
      final ap = Provider.of<PlaceService>(context,listen: false);


      final List<String> imageUrls = await Future.wait(
        images.map((file) async {
          final Reference ref = FirebaseStorage.instance
              .ref()
              .child('sights')
              .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
          final UploadTask uploadTask = ref.putFile(File(file.path!));
          final TaskSnapshot downloadUrl = await uploadTask;
          return (await downloadUrl.ref.getDownloadURL()).toString();
        }).toList(),
      );

      PlaceModel place = PlaceModel(
          FirebaseFirestore.instance.collection('sights').doc().id,
          _nameController.text,
          _descriptionController.text,
          imageUrls,
          double.parse(_location_lat.text),
          double.parse(_location_lng.text),
      );



      ap.addPlace(place);
      logger.i("Данные успешно добавлено");
      Navigator.popUntil(context, (route) => false);
    }
    catch(e){
      logger.e("Что-то пошло не так! $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  MultiImagePickerView(
                    onChange: (Iterable<ImageFile> list) {
                      setState(() {
                        images.addAll(list);
                      });
                    },
                    controller: controller,
                  ),

                  SizedBox(height: 20,),

                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      label: const Text('Названия'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),

                  TextField(
                    controller: _descriptionController,
                    textInputAction: TextInputAction.done,
                    maxLines: null,
                    decoration: InputDecoration(
                      label: const Text('Описания'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),


                  SizedBox(height: 20,),

                  TextField(
                    controller: _location_lat,
                    decoration: InputDecoration(
                      label: const Text('долгота'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  TextField(
                    controller: _location_lng,
                    decoration: InputDecoration(
                      label: const Text('широта'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  SaveElevatedButton(height: 50, text: "Сохранить", onPressed: addPlace),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }


}


