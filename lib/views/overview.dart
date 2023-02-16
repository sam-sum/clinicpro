import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:clinicpro/views/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:clinicpro/utilities/styles.dart';
import 'package:clinicpro/models/patient_model.dart';

import '../utilities/screen_size.dart';
import '../widgets/stateless_button.dart';

Future<List<Patient>> fatchPatient(http.Client client) async {
  String link = "https://gp5.onrender.com/patients";
  var res = await http.get(Uri.parse(link));

  if (res.statusCode == 200) {
    var data = json.decode(res.body);
    var rest = data["data"] as List;
    var list = rest.map<Patient>((json) => Patient.fromJson(json)).toList();
    return list;
  }
  throw Exception("Fail to load patient");
}

class FilterBottom extends StatefulWidget {
  const FilterBottom({super.key});

  @override
  State<FilterBottom> createState() => _FilterBottom();
}

class _FilterBottom extends State<FilterBottom> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String? checkEmptyValidator(value) {
      if (value!.isEmpty)
        return 'Missing';
      else
        return null;
    }

    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Filter',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: getProrataHeight(20)),
              Text('Blood Pressure'),
              TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(),
                  )),
              SizedBox(height: getProrataHeight(10)),
              Text('Blood Oxygen Level'),
              TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(),
                  )),
              SizedBox(height: getProrataHeight(10)),
              Text('Respiratory Rate'),
              TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(),
                  )),
              SizedBox(height: getProrataHeight(10)),
              Text('Heart Beat Rate'),
              TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(),
                  )),
              StatelessButton(
                height: 50,
                buttonText: 'Filter',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}

class PatientList extends StatelessWidget {
  const PatientList({super.key, required this.list});

  final List<Patient> list;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: ((context, index) {
          final item = list[index];
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, PatientDetails.routeName,
                  arguments: item);
            },
            child: Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Image.network(item.photoUrl, errorBuilder:
                                  (context, exception, stackTrace) {
                                return Container();
                              }),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.firstName + ' ' + item.lastName,
                              ),
                              Text(
                                'Gender : ' + item.gender,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.addressCard,
                                    size: 15,
                                  ),
                                  Text(
                                    ' #' + item.idCardNumber,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(),
                              item.disabled == 'true'
                                  ? FaIcon(
                                      FontAwesomeIcons.wheelchair,
                                      size: 15,
                                    )
                                  : Container(),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.bed,
                                    size: 15,
                                  ),
                                  Text(
                                    ' ' + item.bedNumber.toUpperCase(),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: FaIcon(
                            FontAwesomeIcons.ellipsisVertical,
                            size: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
  }
}

class Overview extends StatelessWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Styles.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Text(
                  'All Patient',
                  style: TextStyle(fontSize: 18),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      //elevates modal bottom screen
                      elevation: 20,
                      // gives rounded corner to modal bottom screen
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      builder: (BuildContext context) {
                        // UDE : SizedBox instead of Container for whitespaces
                        return FilterBottom();
                      },
                    );
                  },
                  child: FaIcon(
                    FontAwesomeIcons.filter,
                    size: 15,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
                child: FutureBuilder(
              future: fatchPatient(http.Client()),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Network Error'),
                  );
                } else if (snapshot.hasData) {
                  return PatientList(list: snapshot.data!);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
