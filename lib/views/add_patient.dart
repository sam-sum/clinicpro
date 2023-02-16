import 'package:flutter/material.dart';
import 'package:clinicpro/utilities/styles.dart';
import 'package:flutter/services.dart';

import '../utilities/screen_size.dart';
import '../widgets/stateless_button.dart';

enum SingingCharacter { male, female }

class AddPatient extends StatefulWidget {
  const AddPatient({Key? key}) : super(key: key);

  @override
  State<AddPatient> createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SingingCharacter? _gender = SingingCharacter.male;
  bool isDisabled = false;
  bool isAllergies = false;

  String? checkEmptyValidator(value) {
    if (value!.isEmpty)
      return 'Missing';
    else
      return null;
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
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'ID Number',
                          isDense: true,
                          contentPadding: EdgeInsets.all(14),
                          border: OutlineInputBorder(),
                        ),
                        validator: checkEmptyValidator,
                      ),
                      SizedBox(height: getProrataHeight(15)),
                      Row(
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'YYYY',
                                isDense: true,
                                contentPadding: EdgeInsets.all(14),
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(4),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              validator: checkEmptyValidator,
                            ),
                          ),
                          SizedBox(width: getProrataHeight(15)),
                          new Flexible(
                            child: new TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'MM',
                                isDense: true,
                                contentPadding: EdgeInsets.all(14),
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(2),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              validator: checkEmptyValidator,
                            ),
                          ),
                          SizedBox(width: getProrataHeight(15)),
                          new Flexible(
                            child: new TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'DD',
                                isDense: true,
                                contentPadding: EdgeInsets.all(14),
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(2),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              validator: checkEmptyValidator,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: getProrataHeight(15)),
                      TextFormField(
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
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    labelText: 'Phone',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(14),
                                  ),
                                  validator: checkEmptyValidator,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: getProrataHeight(30)),
                          new Flexible(
                            child: Column(
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    labelText: 'Postal Code',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(14),
                                  ),
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
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Height',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(14),
                                  ),
                                  validator: checkEmptyValidator,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: getProrataHeight(30)),
                          new Flexible(
                            child: Column(
                              children: [
                                new TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Weight',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(14),
                                  ),
                                  validator: checkEmptyValidator,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: getProrataHeight(15)),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Diseases',
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
                              leading: Radio<SingingCharacter>(
                                value: SingingCharacter.male,
                                groupValue: _gender,
                                onChanged: (value) {
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
                                onChanged: (value) {
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
                      ),
                      SizedBox(height: getProrataHeight(15)),
                      StatelessButton(
                        buttonText: 'Validate',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
//    If all data are correct then save data to out variables
                            _formKey.currentState!.save();
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
