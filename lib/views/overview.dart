import 'package:clinicpro/views/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:clinicpro/utilities/styles.dart';
import 'package:clinicpro/models/patient_model.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/Patients.dart';
import '../utilities/screen_size.dart';
import '../widgets/stateless_button.dart';

class Overview extends StatefulWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  var _isInit = true;
  var _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _pressure = '';
  String _lowerpressure = '';
  String _oxygen = '';
  String _respiratory = '';
  String _heartbeat = '';
  List<Patient> patientList = [];
  List<Patient> filterpatientList = [];

  String _oxyDrop = 'Less Than';
  String _resDrop = 'Less Than';
  String _heartDrop = 'Less Than';

  // List of items in our dropdown menu
  var items = [
    'Less Than',
    'Equal',
    'Greater Than',
  ];

  void filterList() {
    filterpatientList = [];
    patientList.forEach((element) {
      var record = element.latestRecord;
      if (record != null) {
        bool filterOut = false;

        if (_pressure.isNotEmpty) {
          if (record.bLOODPRESSURE!.isEmpty) {
            filterOut = true;
          } else {
            int a = int.tryParse(_pressure) ?? 0;
            int b = int.tryParse(record.bLOODPRESSURE!) ?? 0;
            if (!(b <= a)) filterOut = true;
          }
        }

        if (_lowerpressure.isNotEmpty) {
          if (record.bLOODPRESSURE!.isEmpty) {
            filterOut = true;
          } else {
            int a = int.tryParse(_lowerpressure) ?? 0;
            int b = int.tryParse(record.bLOODPRESSURE!) ?? 0;
            if (!(b >= a)) filterOut = true;
          }
        }

        if (!filterOut) filterpatientList.add(element);
      }
    });
  }

  bool checkFilter() {
    return !(_pressure.isEmpty &&
        _lowerpressure.isEmpty &&
        _oxygen.isEmpty &&
        _respiratory.isEmpty &&
        _heartbeat.isEmpty);
  }

  void resetFilter() {
    _pressure = '';
    _lowerpressure = '';
    _oxygen = '';
    _respiratory = '';
    _heartbeat = '';
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Patients>(context).fetchAllPatients().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //final patientsData = Provider.of<Patients>(context);
    patientList = Provider.of<Patients>(context).patients;
    filterList();

    return Material(
        color: Styles.backgroundColor,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
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
                      child: ListView.builder(
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
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                child: Image.network(
                                                    item.photoUrl!,
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons
                                                          .addressCard,
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
                                                        FontAwesomeIcons
                                                            .wheelchair,
                                                        size: 15,
                                                      )
                                                    : Container(),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                          })),
                    ),
                  ],
                ),
              ));
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
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      initialValue: _pressure,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                      onSaved: (val) {
                        _pressure = val!;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Text('/'),
                  ),
                  Flexible(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      initialValue: _lowerpressure,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                      onSaved: (val) {
                        _lowerpressure = val!;
                      },
                    ),
                  ),
                ],
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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
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
