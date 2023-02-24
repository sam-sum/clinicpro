import 'dart:math';

import 'package:flutter/material.dart';
import 'package:clinicpro/utilities/styles.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/patient_model.dart';
import '../providers/Patients.dart';
import '../utilities/screen_size.dart';
import '../widgets/simple_dialogue.dart';
import '../widgets/stateless_button.dart';

const String MALE = "Male";
const String FEMALE = "Female";

class AddPatient extends StatefulWidget {
  const AddPatient({Key? key}) : super(key: key);

  @override
  State<AddPatient> createState() => _AddPatientState();
}

Patient createNewPatient() {
  var uuid = const Uuid();
  Patient patient = Patient();
  patient.id = uuid.v4().toString();
  patient.disabled = false;
  patient.bedNumber = 'A' + Random().nextInt(999).toString().padLeft(3, '0');
  //patient.sId = uuid.v4().toString();
  //patient.createdAt = DateTime.now().toString();
  //patient.updatedAt = DateTime.now().toString();

  patient.email = '';
  patient.doctor = '';

  return patient;
}

class _AddPatientState extends State<AddPatient> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  TextEditingController _dateOfBirthController = TextEditingController();

  TextEditingController _yearController = TextEditingController();
  TextEditingController _monthController = TextEditingController();
  TextEditingController _dayController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _postalcodeController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _diseaseController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _doctorController = TextEditingController();

  String _gender = MALE;

  bool _isDisabled = false;
  bool _isAllergies = false;

  bool _isLoading = false;

  String? checkEmptyValidator(value) {
    if (value!.isEmpty)
      return 'Missing';
    else
      return null;
  }

  void clearAll() {
    _firstNameController.text = '';
    _lastNameController.text = '';
    _idController.text = '';
    _dateOfBirthController.text = '';
    _addressController.text = '';
    _phoneController.text = '';
    _postalcodeController.text = '';
    _heightController.text = '';
    _weightController.text = '';
    _diseaseController.text = '';
    _emailController.text = '';
    _doctorController.text = '';
    _gender = MALE;
    _isDisabled = false;
    _isAllergies = false;
    setState(() {});
  }

  Future<void> submit() async {
    Patient patient = createNewPatient();
    patient.firstName = _firstNameController.text;
    patient.lastName = _lastNameController.text;
    patient.idCardNumber = _idController.text;
    patient.dateOfBirth = _dateOfBirthController.text;

    patient.address = _addressController.text;
    patient.phoneNumber = int.parse(_phoneController.text);
    patient.postalCode = _postalcodeController.text;
    patient.height = double.parse(_heightController.text);
    patient.weight = double.parse(_weightController.text);
    patient.medicalNotes = _diseaseController.text;
    patient.email = _emailController.text;
    patient.doctor = _doctorController.text;
    patient.gender = _gender;

    patient.photoUrl =
        'https://randomuser.me/api/portraits/${_gender == "Male" ? "men" : "women"}/${Random().nextInt(10).toString()}.jpg';

    patient.disabled = _isDisabled;
    patient.medicalAllergies = _isAllergies;

    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Patients>(context, listen: false)
          .createPatient(patient)
          .then((value) {
        showDialog(
          context: context,
          builder: (ctx) => SimpleDialogue(
              header: 'Add patient success!',
              text: '${patient.firstName} ${patient.lastName}'),
        );
        clearAll();
      });
    } catch (error) {
      print(error.toString());
      await showDialog(
        context: context,
        builder: (ctx) => SimpleDialogue(
            header: 'An error occurred!', text: error.toString()),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Styles.backgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _firstNameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          isDense: true,
                          contentPadding: EdgeInsets.all(14),
                          border: OutlineInputBorder(),
                        ),
                        validator: checkEmptyValidator,
                      ),
                      SizedBox(height: getProrataHeight(15)),
                      TextFormField(
                        controller: _lastNameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          isDense: true,
                          contentPadding: EdgeInsets.all(14),
                          border: OutlineInputBorder(),
                        ),
                        validator: checkEmptyValidator,
                      ),
                      SizedBox(height: getProrataHeight(15)),
                      TextFormField(
                        controller: _idController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'ID Number',
                          isDense: true,
                          contentPadding: EdgeInsets.all(14),
                          border: OutlineInputBorder(),
                        ),
                        validator: checkEmptyValidator,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                      ),
                      SizedBox(height: getProrataHeight(15)),
                      TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _dateOfBirthController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Date of Birth',
                            isDense: true,
                            contentPadding: EdgeInsets.all(14),
                          ),
                          readOnly: true,
                          validator: checkEmptyValidator,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime.now());

                            if (pickedDate != null) {
                              print(pickedDate);
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);

                              setState(() {
                                _dateOfBirthController.text = formattedDate;
                              });
                            } else {
                              print("Date is not selected");
                            }
                          }),
                      // Row(
                      //   children: <Widget>[
                      //     new Flexible(
                      //       child: new TextFormField(
                      //         controller: _yearController,
                      //         keyboardType: TextInputType.number,
                      //         decoration: const InputDecoration(
                      //           border: OutlineInputBorder(),
                      //           labelText: 'YYYY',
                      //           isDense: true,
                      //           contentPadding: EdgeInsets.all(14),
                      //         ),
                      //         inputFormatters: [
                      //           LengthLimitingTextInputFormatter(4),
                      //           FilteringTextInputFormatter.allow(
                      //               RegExp(r'[0-9]')),
                      //         ],
                      //         validator: checkEmptyValidator,
                      //       ),
                      //     ),
                      //     SizedBox(width: getProrataHeight(15)),
                      //     new Flexible(
                      //       child: new TextFormField(
                      //         controller: _monthController,
                      //         keyboardType: TextInputType.number,
                      //         decoration: const InputDecoration(
                      //           border: OutlineInputBorder(),
                      //           labelText: 'MM',
                      //           isDense: true,
                      //           contentPadding: EdgeInsets.all(14),
                      //         ),
                      //         inputFormatters: [
                      //           LengthLimitingTextInputFormatter(2),
                      //           FilteringTextInputFormatter.allow(
                      //               RegExp(r'[0-9]')),
                      //         ],
                      //         validator: checkEmptyValidator,
                      //       ),
                      //     ),
                      //     SizedBox(width: getProrataHeight(15)),
                      //     new Flexible(
                      //       child: new TextFormField(
                      //         controller: _dayController,
                      //         keyboardType: TextInputType.number,
                      //         decoration: const InputDecoration(
                      //           border: OutlineInputBorder(),
                      //           labelText: 'DD',
                      //           isDense: true,
                      //           contentPadding: EdgeInsets.all(14),
                      //         ),
                      //         inputFormatters: [
                      //           LengthLimitingTextInputFormatter(2),
                      //           FilteringTextInputFormatter.allow(
                      //               RegExp(r'[0-9]')),
                      //         ],
                      //         validator: checkEmptyValidator,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(height: getProrataHeight(15)),
                      TextFormField(
                        controller: _addressController,
                        keyboardType: TextInputType.streetAddress,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.all(14),
                        ),
                        validator: checkEmptyValidator,
                      ),
                      SizedBox(height: getProrataHeight(15)),
                      Row(
                        children: <Widget>[
                          new Flexible(
                            child: Column(
                              children: [
                                new TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    labelText: 'Phone',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(14),
                                  ),
                                  validator: checkEmptyValidator,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: getProrataHeight(30)),
                          new Flexible(
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _postalcodeController,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    labelText: 'Postal Code',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(14),
                                  ),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(6),
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9a-zA-Z]')),
                                  ],
                                  validator: checkEmptyValidator,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: getProrataHeight(15)),
                      Row(
                        children: <Widget>[
                          new Flexible(
                            child: Column(
                              children: [
                                new TextFormField(
                                  controller: _heightController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Height',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(14),
                                  ),
                                  validator: checkEmptyValidator,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9.]')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: getProrataHeight(30)),
                          new Flexible(
                            child: Column(
                              children: [
                                new TextFormField(
                                  controller: _weightController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Weight',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(14),
                                  ),
                                  validator: checkEmptyValidator,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9.]')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: getProrataHeight(15)),
                      TextFormField(
                        controller: _diseaseController,
                        decoration: InputDecoration(
                          labelText: 'Diseases',
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.all(14),
                        ),
                        validator: checkEmptyValidator,
                      ),
                      SizedBox(height: getProrataHeight(15)),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.all(14),
                        ),
                        validator: checkEmptyValidator,
                      ),
                      SizedBox(height: getProrataHeight(15)),
                      TextFormField(
                        controller: _doctorController,
                        decoration: InputDecoration(
                          labelText: 'Doctor',
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.all(14),
                        ),
                        validator: checkEmptyValidator,
                      ),
                      SizedBox(height: getProrataHeight(15)),
                      Row(
                        children: [
                          Flexible(
                            child: ListTile(
                              title: const Text('Male'),
                              leading: Radio<String>(
                                value: MALE,
                                groupValue: _gender,
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                          Flexible(
                            child: ListTile(
                              title: const Text('Female'),
                              leading: Radio<String>(
                                value: FEMALE,
                                groupValue: _gender,
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Align(
                            child: Container(
                              child: Row(
                                children: [
                                  Text(
                                    "Disabled?",
                                    style: TextStyle(
                                      fontSize: getProrataWidth(16),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  FaIcon(
                                    FontAwesomeIcons.wheelchair,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          Switch(
                            value: _isDisabled,
                            onChanged: (value) => {
                              setState(() {
                                _isDisabled = value;
                              })
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Align(
                            child: Container(
                              child: Text(
                                "Medical Allergies?",
                                style: TextStyle(
                                  fontSize: getProrataWidth(16),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Switch(
                            value: _isAllergies,
                            onChanged: (value) => {
                              setState(() {
                                _isAllergies = value;
                              })
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: getProrataHeight(15)),
                      StatelessButton(
                        buttonText: 'Submit',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            submit();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
