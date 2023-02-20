import 'dart:convert';
import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:clinicpro/views/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:clinicpro/utilities/styles.dart';
import 'package:clinicpro/models/patient_model.dart';

import '../utilities/screen_size.dart';
import '../widgets/stateless_button.dart';

Future<List<Patient>> fetchPatient(http.Client client) async {
  //String link = "https://rest-clinicpro.onrender.com/patients";
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

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _pressure = '';
  String _oxygen = '';
  String _respiratory = '';
  String _heartbeat = '';
  List<Patient> patientList = [];
  List<Patient> filterpatientList = [];

  void filterList() {
    filterpatientList = [];
    patientList.forEach((element) {
      var record = element.latestRecord;
      if (record != null) {
        bool flag = true;
        String bloodPressure = record.bLOODPRESSURE ?? '';
        String oxygen = record.bLOODPRESSURE ?? '';
        String respiratory = record.bLOODPRESSURE ?? '';
        String heartbeat = record.bLOODPRESSURE ?? '';

        if (!bloodPressure.toLowerCase().contains(_pressure.toLowerCase()))
          flag = false;
        if (!oxygen.toLowerCase().contains(_oxygen.toLowerCase())) flag = false;
        if (!respiratory.toLowerCase().contains(_respiratory.toLowerCase()))
          flag = false;
        if (!heartbeat.toLowerCase().contains(_heartbeat.toLowerCase()))
          flag = false;

        if (flag) filterpatientList.add(element);
      }
    });
  }

  bool checkFilter() {
    return !(_pressure.isEmpty &&
        _oxygen.isEmpty &&
        _respiratory.isEmpty &&
        _heartbeat.isEmpty);
  }

  void resetFilter() {
    _pressure = '';
    _oxygen = '';
    _respiratory = '';
    _heartbeat = '';
  }

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
                        return FilterBottom(context);
                      },
                    );
                  },
                  child: FaIcon(FontAwesomeIcons.filter,
                      size: 15,
                      color: checkFilter()
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).disabledColor),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
                child: FutureBuilder(
              future: fetchPatient(http.Client()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Network Error'),
                  );
                } else {
                  patientList = snapshot.data!;
                  filterList();

                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: filterpatientList.length,
                      itemBuilder: ((context, index) {
                        var item = filterpatientList[index];
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, PatientDetails.routeName,
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
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            child: Image.network(item.photoUrl!,
                                                errorBuilder: (context,
                                                    exception, stackTrace) {
                                              return Container();
                                            }),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.firstName! +
                                                  ' ' +
                                                  item.lastName!,
                                            ),
                                            Text(
                                              'Gender : ' + item.gender!,
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                FaIcon(
                                                  FontAwesomeIcons.addressCard,
                                                  size: 15,
                                                ),
                                                Text(
                                                  ' #' + item.idCardNumber!,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                  ' ' +
                                                      item.bedNumber!
                                                          .toUpperCase(),
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
              },
            )),
          ],
        ),
      ),
    );
  }

  Widget FilterBottom(BuildContext context) {
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
                textAlign: TextAlign.center,
                initialValue: _pressure,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(),
                ),
                onSaved: (val) {
                  _pressure = val!;
                },
              ),
              SizedBox(height: getProrataHeight(10)),
              Text('Blood Oxygen Level'),
              TextFormField(
                textAlign: TextAlign.center,
                initialValue: _oxygen,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(),
                ),
                onSaved: (val) {
                  _oxygen = val!;
                },
              ),
              SizedBox(height: getProrataHeight(10)),
              Text('Respiratory Rate'),
              TextFormField(
                textAlign: TextAlign.center,
                initialValue: _respiratory,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(),
                ),
                onSaved: (val) {
                  _respiratory = val!;
                },
              ),
              SizedBox(height: getProrataHeight(10)),
              Text('Heart Beat Rate'),
              TextFormField(
                textAlign: TextAlign.center,
                initialValue: _heartbeat,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(),
                ),
                onSaved: (val) {
                  _heartbeat = val!;
                },
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: StatelessButton(
                      height: 45,
                      buttonText: 'Filter',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() {
                            filterList();
                          });
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  checkFilter()
                      ? Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: StatelessButton(
                              height: 45,
                              buttonText: 'Reset',
                              onPressed: () {
                                setState(() {
                                  resetFilter();
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
