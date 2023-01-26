import 'package:flutter/material.dart';
import 'package:clinicpro/utilities/styles.dart';
import 'package:flutter/services.dart';

import '../utilities/screen_size.dart';

enum SingingCharacter { male, female }

class AddPatient extends StatefulWidget {
  const AddPatient({Key? key}) : super(key: key);

  @override
  State<AddPatient> createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {
  SingingCharacter? _gender;

  bool isDisabled = false;
  bool isAllergies = false;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Styles.backgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "First Name",
                          style: TextStyle(
                            fontSize: getProrataWidth(14),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TextField(
                        decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(14),
                      border: OutlineInputBorder(),
                    )),
                    SizedBox(height: getProrataHeight(15)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "Last Name",
                          style: TextStyle(
                            fontSize: getProrataWidth(14),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TextField(
                        decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(14),
                      border: OutlineInputBorder(),
                    )),
                    SizedBox(height: getProrataHeight(15)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "ID Number",
                          style: TextStyle(
                            fontSize: getProrataWidth(14),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TextField(
                        decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(14),
                      border: OutlineInputBorder(),
                    )),
                    SizedBox(height: getProrataHeight(15)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "Birth",
                          style: TextStyle(
                            fontSize: getProrataWidth(14),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        new Flexible(
                          child: new TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'YYYY',
                              isDense: true,
                              contentPadding: EdgeInsets.all(14),
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(4),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: getProrataHeight(15)),
                        new Flexible(
                          child: new TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'MM',
                              isDense: true,
                              contentPadding: EdgeInsets.all(14),
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(2),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: getProrataHeight(15)),
                        new Flexible(
                          child: new TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'DD',
                              isDense: true,
                              contentPadding: EdgeInsets.all(14),
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(2),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: getProrataHeight(15)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "Address",
                          style: TextStyle(
                            fontSize: getProrataWidth(14),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TextField(
                        decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.all(14),
                    )),
                    SizedBox(height: getProrataHeight(15)),
                    Row(
                      children: <Widget>[
                        new Flexible(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: Text(
                                    "Phone",
                                    style: TextStyle(
                                      fontSize: getProrataWidth(14),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              new TextField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(14),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: getProrataHeight(30)),
                        new Flexible(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: Text(
                                    "Postal Code",
                                    style: TextStyle(
                                      fontSize: getProrataWidth(14),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              new TextField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(14),
                                ),
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
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: Text(
                                    "Height",
                                    style: TextStyle(
                                      fontSize: getProrataWidth(14),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              new TextField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(14),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: getProrataHeight(30)),
                        new Flexible(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: Text(
                                    "Weight",
                                    style: TextStyle(
                                      fontSize: getProrataWidth(14),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              new TextField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: getProrataHeight(15)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "Diseases",
                          style: TextStyle(
                            fontSize: getProrataWidth(14),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TextField(
                        decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.all(14),
                    )),
                    SizedBox(height: getProrataHeight(15)),
                    Row(
                      children: [
                        Flexible(
                          child: ListTile(
                            title: const Text('Male'),
                            leading: Radio<SingingCharacter>(
                              value: SingingCharacter.male,
                              groupValue: _gender,
                              onChanged: (SingingCharacter? value) {
                                setState(() {
                                  _gender = value;
                                });
                              },
                            ),
                          ),
                        ),
                        Flexible(
                          child: ListTile(
                            title: const Text('Female'),
                            leading: Radio<SingingCharacter>(
                              value: SingingCharacter.female,
                              groupValue: _gender,
                              onChanged: (SingingCharacter? value) {
                                setState(() {
                                  _gender = value;
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
                            child: Text(
                              "Disabled?",
                              style: TextStyle(
                                fontSize: getProrataWidth(18),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Switch(
                          value: isDisabled,
                          onChanged: (value) => {
                            setState(() {
                              isDisabled = value;
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
                                fontSize: getProrataWidth(18),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Switch(
                          value: isAllergies,
                          onChanged: (value) => {
                            setState(() {
                              isAllergies = value;
                            })
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
