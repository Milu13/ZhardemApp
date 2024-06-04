import 'dart:io';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:provider/provider.dart';
import 'package:zhardem/models/accident.dart';
import 'package:zhardem/models/step.dart';
import 'package:zhardem/services/accidentService.dart';
import '../widgets/saveElevatedButton.dart';

class AddAccidentScreen extends StatefulWidget {
  const AddAccidentScreen({super.key});

  @override
  State<AddAccidentScreen> createState() => _AddAccidentScreenState();
}

class _AddAccidentScreenState extends State<AddAccidentScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _pageTitleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  List<TextEditingController> _stepTitleControllers = [];
  List<TextEditingController> _stepDescriptionControllers = [];
  List<Widget> stepsFields = [];

  void _addStepsField() {
    final stepTitleController = TextEditingController();
    final stepDescriptionController = TextEditingController();

    setState(() {
      _stepTitleControllers.add(stepTitleController);
      _stepDescriptionControllers.add(stepDescriptionController);
      stepsFields.add(
        Column(
          children: [
            TextField(
              controller: stepTitleController,
              decoration: InputDecoration(
                labelText: 'Шаг',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: stepDescriptionController,
              decoration: InputDecoration(
                labelText: 'Описание',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    });
  }

  final controller = MultiImagePickerController(
    maxImages: 1, // Максимальное количество изображений, которые можно выбрать
    withReadStream: true, // Указываем, что нам нужны данные в виде байтов (stream)
    allowedImageTypes: ['png', 'jpg', 'jpeg'], // Разрешенные форматы изображений
  );
  File? images;

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  void addAccident() async {
    try {
      final ap = Provider.of<AccidentService>(context, listen: false);

      List<Steps> steps = [];
      for (var i = 0; i < _stepTitleControllers.length; i++) {
        var step = Steps(
          stepsTitle: _stepTitleControllers[i].text,
          title: _stepTitleControllers[i].text,
          description: _stepDescriptionControllers[i].text,
        );
        steps.add(step);
      }

      logger.i(images.toString());
      Accident accident = Accident(
        title: _titleController.text,
        pageTitle: _pageTitleController.text,
        photoUrl: "",
        description: _descriptionController.text,
        steps: steps,
      );

      await ap.addAccident(context, accident, images);
      logger.i("Данные успешно загружены");
    } catch (e) {
      logger.e("Что-то пошло не так! $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Добавить что-то"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                MultiImagePickerView(
                  onChange: (Iterable<ImageFile> list) {
                    setState(() {
                      final firstImagePath = list.isNotEmpty ? list.first.path : null;
                      if (firstImagePath != null) {
                        images = File(firstImagePath);
                        logger.i(images.toString());
                      } else {
                        logger.e('Путь к изображению равен null');
                      }
                    });
                  },
                  controller: controller,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _titleController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: "Заголовок",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _pageTitleController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: "Заголовок страницы",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Описание",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    for (var i = 0; i < stepsFields.length; i++) stepsFields[i],
                  ],
                ),
                SizedBox(height: 10),
                SaveElevatedButton(
                  height: 40,
                  text: "Добавить шаг",
                  onPressed: () {
                    _addStepsField();
                  },
                ),
                SizedBox(height: 25),
                SaveElevatedButton(
                  height: 50,
                  text: "Сохранить",
                  onPressed: addAccident,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
