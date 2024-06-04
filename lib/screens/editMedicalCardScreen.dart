import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../models/Contacts.dart';
import '../models/medicalRecordModel.dart';
import '../models/personalDataModel.dart';
import '../services/MedicalCardService.dart';
import '../services/customSnackBar.dart';
import '../widgets/saveElevatedButton.dart';
import '../widgets/usernameTextField.dart';

class EditMedicalCardScreen extends StatefulWidget {
  const EditMedicalCardScreen({Key? key}) : super(key: key);

  @override
  _EditMedicalCardScreenState createState() => _EditMedicalCardScreenState();
}

class _EditMedicalCardScreenState extends State<EditMedicalCardScreen> {
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  TextEditingController fullNameController = TextEditingController();
  TextEditingController iinController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController citizenshipController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController familyStatusController = TextEditingController();
  TextEditingController conditionsController = TextEditingController();
  String selectedGender = 'Мужской';

  MedicalCardService _medicalCardService = MedicalCardService();

  List<TextField> medicalHistoryFields = [];
  List<TextField> allergiesFields = [];
  List<TextField> medicationsFields = [];
  List<Column> emergencyContactsFields = [];

  @override
  void initState() {
    super.initState();
    _medicalCardService.getMedicalRecord().then((_) {
      setState(() {
        fullNameController.text = _medicalCardService.fullName;
        iinController.text = _medicalCardService.iin;
        birthDateController.text = _medicalCardService.birthDate;
        selectedGender = _medicalCardService.gender;
        nationalityController.text = _medicalCardService.nationality;
        citizenshipController.text = _medicalCardService.citizenship;
        addressController.text = _medicalCardService.address;
        familyStatusController.text = _medicalCardService.familyStatus;

        _medicalCardService.medicalHistory.forEach((entry) {
          medicalHistoryFields.add(TextField(controller: TextEditingController(text: entry)));
        });

        _medicalCardService.allergies.forEach((entry) {
          allergiesFields.add(TextField(controller: TextEditingController(text: entry)));
        });

        _medicalCardService.medications.forEach((entry) {
          medicationsFields.add(TextField(controller: TextEditingController(text: entry)));
        });

        _medicalCardService.emergencyContacts.forEach((contact) {
          _addEmergencyContactField(
            name: contact.contactName,
            phone: contact.phoneNumber,
            email: contact.emailAddress,
          );
        });
      });
    });
  }

  void _addEmergencyContactField({String? name, String? phone, String? email}) {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController phoneController = TextEditingController(text: phone);
    TextEditingController emailController = TextEditingController(text: email);

    setState(() {
      emergencyContactsFields.add(
        Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: 'Имя контакта',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                  labelText: 'Номер телефона',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: 'Адрес электронной почты',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    });
  }

  void _showDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        birthDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _addTextField(List<TextField> controller) {
    setState(() {
      controller.add(TextField(
        controller: TextEditingController(),
        decoration: InputDecoration(
            labelText: 'Запись ${controller.length + 1}',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
      ));
    });
  }

  Future<void> updateMedicalCard() async {
    try {
      List<String> medicalHistory = medicalHistoryFields.map((textField) => textField.controller!.text).toList();
      List<String> allergies = allergiesFields.map((textField) => textField.controller!.text).toList();
      List<String> medications = medicationsFields.map((textField) => textField.controller!.text).toList();
      List<Contacts> emergencyContacts = emergencyContactsFields.map((column) {
        var nameController = column.children[0] as TextField;
        var phoneController = column.children[1] as TextField;
        var emailController = column.children[2] as TextField;
        return Contacts(
          contactName: nameController.controller!.text,
          phoneNumber: phoneController.controller!.text,
          emailAddress: emailController.controller!.text,
        );
      }).toList();

      var personalData = PersonalDataModel(
        fullName: fullNameController.text,
        iin: iinController.text,
        birthDate: birthDateController.text,
        gender: selectedGender,
        nationality: nationalityController.text,
        citizenship: citizenshipController.text,
        address: addressController.text,
        familyStatus: familyStatusController.text,
        emergencyContacts: emergencyContacts, medicalHistory: [],
      );

      var medicalRecord = MedicalRecord(
        personalData: personalData,
        medicalHistory: medicalHistory,
        allergies: allergies,
        medications: medications,
        conditions: conditionsController.text.split('\n'),
      );

      await _medicalCardService.updateMedicalCard(medicalRecord);
      await CustomSnackBar.showSnackBar(context, 'Данные успешно обновлены', false);
      Navigator.pop(context);
    } catch (e) {
      CustomSnackBar.showSnackBar(context, 'Что-то пошло не так при обновлении', true);
      logger.e("Что-то пошло не так при обновлении! \n $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактирование данных'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UsernameTextField(usernameController: fullNameController, hint: 'ФИО'),
              const SizedBox(height: 16),
              TextFormField(
                controller: iinController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  hintText: 'ИИН',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: birthDateController,
                readOnly: true,
                onTap: _showDatePicker,
                decoration: InputDecoration(
                  labelText: 'Дата рождения',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedGender,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGender = newValue!;
                  });
                },
                items: <String>['Мужской', 'Женский']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  labelText: 'Пол',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nationalityController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  hintText: 'Национальность',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: citizenshipController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  hintText: 'Гражданство',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  hintText: 'Адрес',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: familyStatusController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  hintText: 'Семейное положение',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: conditionsController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  hintText: 'Состояния',
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('История болезни:'),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      for (var field in medicalHistoryFields) field,
                      SaveElevatedButton(
                        height: 40,
                        text: 'Добавить запись',
                        onPressed: () => _addTextField(medicalHistoryFields),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Аллергии:'),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      for (var field in allergiesFields) field,
                      SaveElevatedButton(
                        height: 40,
                        text: 'Добавить запись',
                        onPressed: () => _addTextField(allergiesFields),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Лекарства:'),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      for (var field in medicationsFields) field,
                      SaveElevatedButton(
                        height: 40,
                        text: 'Добавить запись',
                        onPressed: () => _addTextField(medicationsFields),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Экстренные контакты:'),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      for (var field in emergencyContactsFields) field,
                      SaveElevatedButton(
                        height: 40,
                        text: 'Добавить контакт',
                        onPressed: () => _addEmergencyContactField(),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SaveElevatedButton(
                height: 50,
                text: 'Сохранить',
                onPressed: updateMedicalCard,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
