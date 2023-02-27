import 'package:clinicpro/utilities/screen_size.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:clinicpro/utilities/styles.dart';
import 'package:clinicpro/models/patient_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/vital_sign_model.dart';
import '../providers/vital_signs.dart';
import '../widgets/simple_dialogue.dart';
import '../widgets/stateless_button.dart';
import '../assets/constants.dart' as constants;
import '../assets/enum_test_category.dart';

class MedicalRecords extends StatefulWidget {
  const MedicalRecords({Key? key}) : super(key: key);

  static const routeName = '/medicalRecords';

  @override
  State<MedicalRecords> createState() => _MedicalRecordsState();
}

class _MedicalRecordsState extends State<MedicalRecords>
    with SingleTickerProviderStateMixin {
  late SharedPreferences prefs;
  late String _nurseName;
  late Patient _patient;
  bool _isInit = true;
  bool _isLoading = false;

  // Tab controls
  late TabController _tabController;
  int _activeIndex = 0;

  // Vital signs records master lists
  late List<VitalSign> _bloodPressureRecords;
  late List<VitalSign> _heatBeatRateRecords;
  late List<VitalSign> _respiratoryRateRecords;
  late List<VitalSign> _bloodOxygenLevelRecords;

  // Use with inputDialog
  TextEditingController _field1Controller = TextEditingController();
  TextEditingController _field2Controller = TextEditingController();
  int? value1, value2;
  String? get _errorText1 {
    if (_field1Controller.value.text.isEmpty) {
      return 'Can\'t be empty';
    }
    num check;
    try {
      check = double.parse(_field1Controller.value.text);
    } catch (error) {
      check = -1;
    }
    if (check < 0) {
      return 'Can\'t be negative';
    }
    // return null if the text is valid
    return null;
  }

  String? get _errorText2 {
    if (_field2Controller.value.text.isEmpty) {
      return 'Can\'t be empty';
    }
    num check;
    try {
      check = double.parse(_field2Controller.value.text);
    } catch (error) {
      check = -1;
    }
    if (check < 0) {
      return 'Can\'t be negative';
    }
    // return null if the text is valid
    return null;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
    _tabController.addListener(() {
      setState(() {
        _activeIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _field1Controller.dispose();
    _field2Controller.dispose();
    super.dispose();
  }

  @override
  Future<void> didChangeDependencies() async {
    _patient = ModalRoute.of(context)!.settings.arguments as Patient;

    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<VitalSigns>(context, listen: false)
          .fetchAllVitalSignsForPatient(_patient.id!)
          .catchError((error) {
        if (kDebugMode) {
          print('Get vital signs records error: $error');
        }
        showDialog(
          context: context,
          builder: (ctx) => const SimpleDialogue(
              header: 'Network error!',
              text: 'Cannot get patient exam records.  Please retry.'),
        );
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      prefs = await SharedPreferences.getInstance();
      _nurseName = prefs.getString(constants.LOGIN_USER) ?? constants.ADMIN;
      if (kDebugMode) {
        print("login nurse name: $_nurseName");
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _bloodPressureRecords = Provider.of<VitalSigns>(context)
        .getBloodPressureRecordsForPatient(_patient.id!);
    _heatBeatRateRecords = Provider.of<VitalSigns>(context)
        .getHeatBeatRateRecordsForPatient(_patient.id!);
    _respiratoryRateRecords = Provider.of<VitalSigns>(context)
        .getRespiratoryRateRecordsForPatient(_patient.id!);
    _bloodOxygenLevelRecords = Provider.of<VitalSigns>(context)
        .getBloodOxygenLevelRecordsForPatient(_patient.id!);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.backgroundColor,
        actions: <Widget>[
          IconButton(
            icon: const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
            tooltip: 'Add a new record',
            onPressed: () {
              VitalSign newReading = createEmptyRecord();
              _displayInputDialog(context, newReading, true);
            },
          ),
        ],
        title: Text(
          'Vital Signs Records',
          style: TextStyle(
            color: Styles.blackColor,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(flex: 6, child: _nameCard(context)),
                    _patient.photoUrl == null
                        ? const SizedBox(
                            width: 110,
                          )
                        : Container(
                            width: 110,
                            margin: const EdgeInsets.fromLTRB(22, 5, 22, 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image(
                                image: NetworkImage(_patient.photoUrl!),
                              ),
                            ),
                          ),
                  ],
                ),
                // the tab bar with 4 items
                SizedBox(
                  height: 50,
                  child: AppBar(
                    backgroundColor: Colors.white,
                    bottom: TabBar(
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.black,
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: Colors.lightBlue,
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Blood Pressure'),
                        Tab(text: 'Heart Beat Rate'),
                        Tab(text: 'Respiratory Rate'),
                        Tab(text: 'Blood Oxygen Level'),
                      ],
                    ),
                  ),
                ),
                // create widgets for each tab bar here
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTab(context, TestCategory.BLOOD_PRESSURE),
                      _buildTab(context, TestCategory.HEARTBEAT_RATE),
                      _buildTab(context, TestCategory.RESPIRATORY_RATE),
                      _buildTab(context, TestCategory.BLOOD_OXYGEN_LEVEL),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _nameCard(BuildContext context) {
    final DateTime? bod = _patient.dateOfBirth == null
        ? null
        : DateTime.parse(_patient.dateOfBirth!);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedDob =
        bod == null ? 'No record' : formatter.format(bod);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.fromLTRB(25, 25, 0, 12),
      elevation: 10.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                  child: Text(
                    "Name: ${_patient.firstName} ${_patient.lastName}",
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text("Birth: $formattedDob"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text("Blood Type: O"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: FaIcon(
                  ((_patient.gender ?? '').toLowerCase() == 'male')
                      ? FontAwesomeIcons.person
                      : FontAwesomeIcons.personDress,
                  size: 18,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 12),
            child: Text("Doctor: ${_patient.doctor ?? 'Not assigned yet'}"),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, TestCategory category) {
    List<VitalSign> readings;
    switch (category) {
      case TestCategory.BLOOD_PRESSURE:
        readings = _bloodPressureRecords;
        break;
      case TestCategory.HEARTBEAT_RATE:
        readings = _heatBeatRateRecords;
        break;
      case TestCategory.RESPIRATORY_RATE:
        readings = _respiratoryRateRecords;
        break;
      case TestCategory.BLOOD_OXYGEN_LEVEL:
        readings = _bloodOxygenLevelRecords;
        break;
    }
    final DateFormat formatter = DateFormat('yyyy-MM-dd h:mm a');

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: readings.map((readingOne) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.fromLTRB(10, 15, 10, 15),
              elevation: 10.0,
              child: InkWell(
                onTap: () {
                  //print("record ID: ${readingOne.id}");
                  _displayInputDialog(context, readingOne, false);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                      child: Row(
                        children: <Widget>[
                          const Expanded(flex: 4, child: Text("Readings:")),
                          Expanded(
                              flex: 6,
                              child: Center(
                                  child: Text(
                                      (readingOne.readings ?? "No Record")
                                          .replaceAll(',', '          ')))),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                      child: Row(
                        children: <Widget>[
                          const Expanded(flex: 4, child: Text("Nurse:")),
                          Expanded(
                              flex: 6,
                              child: Center(
                                  child: Text(
                                      readingOne.nurseName ?? "No Record")))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                      child: Row(
                        children: <Widget>[
                          const Expanded(
                              flex: 4, child: Text("Last updated at:")),
                          Expanded(
                            flex: 6,
                            child: Center(
                              child: Text((readingOne.modifyDate == null)
                                  ? ""
                                  : formatter.format(
                                      DateTime.parse(readingOne.modifyDate!))),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Row(
                        children: <Widget>[
                          const Expanded(flex: 4, child: Text("Created at:")),
                          Expanded(
                            flex: 6,
                            child: Center(
                              child: Text(formatter.format(
                                  DateTime.parse(readingOne.createdAt!))),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  VitalSign createEmptyRecord() {
    var uuid = const Uuid();
    VitalSign newRec = VitalSign();
    newRec.id = uuid.v4().toString();
    //print("uuid: ${newRec.id}");
    newRec.patientId = _patient.id;
    newRec.nurseName = _nurseName;
    newRec.modifyDate = DateTime.now().toString();
    switch (_activeIndex) {
      case 0: //Blood Pressure
        newRec.category = TestCategory.BLOOD_PRESSURE.toShortString();
        newRec.readings = "0,0";
        break;
      case 1: //Heart Beat Rate
        newRec.category = TestCategory.HEARTBEAT_RATE.toShortString();
        newRec.readings = "0";
        break;
      case 2: //Respiratory Rate
        newRec.category = TestCategory.RESPIRATORY_RATE.toShortString();
        newRec.readings = "0";
        break;
      case 3: //Blood Oxygen Level
        newRec.category = TestCategory.BLOOD_OXYGEN_LEVEL.toShortString();
        newRec.readings = "0";
        break;
    }
    newRec.isValid = true;
    return newRec;
  }

  Future<void> _displayInputDialog(
      BuildContext context, VitalSign record, bool isAddMode) async {
    int? defaultValue1;
    int? defaultValue2;
    if (isAddMode) {
      //default inputs to blank
      defaultValue1 = null;
      defaultValue2 = null;
      value1 = null;
      value2 = null;
      _field1Controller = TextEditingController(text: '');
      _field2Controller = TextEditingController(text: '');
    } else {
      //In edit mode, use the existing values as defaults
      defaultValue1 = int.parse((record.readings ?? '').split(',')[0]);
      value1 = defaultValue1;
      _field1Controller = TextEditingController(text: defaultValue1.toString());
      // Only the blood pressure value is split-able into 2 parts
      if (record.category == TestCategory.BLOOD_PRESSURE.toShortString()) {
        defaultValue2 = int.parse((record.readings ?? '').split(',')[1]);
        value2 = defaultValue2;
        _field2Controller =
            TextEditingController(text: defaultValue2.toString());
      } else {
        defaultValue2 = null;
        _field2Controller = TextEditingController(text: '');
      }
    }
    bool isSubmitted = false;

    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              title:
                  Center(child: Text(isAddMode ? 'Add Record' : 'Edit Record')),
              titleTextStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              content: Builder(builder: (context) {
                var width = MediaQuery.of(context).size.width;
                return SizedBox(
                    width: width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text(
                            record.category!.replaceAll('_', ' '),
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              //Input Field 1
                              Expanded(
                                flex: 4,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      try {
                                        value1 = int.parse(value);
                                      } catch (error) {
                                        value1 = defaultValue1;
                                      }
                                    });
                                  },
                                  controller: _field1Controller,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    filled: true,
                                    labelText: (record.category ==
                                            TestCategory.BLOOD_PRESSURE
                                                .toShortString())
                                        ? "Upper"
                                        : "",
                                    fillColor: Colors.white70,
                                    isDense: true,
                                    errorText: isSubmitted ? _errorText1 : null,
                                  ),
                                ),
                              ),
                              //Filler between 2 input fields
                              (record.category !=
                                      TestCategory.BLOOD_PRESSURE
                                          .toShortString())
                                  ? const Center()
                                  : Expanded(
                                      child: SizedBox(
                                        width: getProrataWidth(10.0),
                                      ),
                                    ),
                              //Input Field 2 for blood pressure input only
                              (record.category !=
                                      TestCategory.BLOOD_PRESSURE
                                          .toShortString())
                                  ? const Center()
                                  : Expanded(
                                      flex: 4,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          setState(() {
                                            try {
                                              value2 = int.parse(value);
                                            } catch (error) {
                                              value2 = defaultValue2;
                                            }
                                          });
                                        },
                                        controller: _field2Controller,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          filled: true,
                                          labelText: "Lower",
                                          fillColor: Colors.white70,
                                          isDense: true,
                                          errorText:
                                              isSubmitted ? _errorText2 : null,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ));
              }),
              actions: <Widget>[
                StatelessButton(
                  width: 200,
                  buttonText: 'Submit',
                  onPressed: () {
                    if (record.category ==
                        TestCategory.BLOOD_PRESSURE.toShortString()) {
                      setState(() {
                        isSubmitted = true;
                      });
                      if (_errorText1 == null && _errorText2 == null) {
                        record.readings = '$value1,$value2';
                        _saveReadings();
                        Navigator.pop(context);
                      }
                    } else {
                      // 1 input field only for other vital signs inputs
                      setState(() {
                        isSubmitted = true;
                      });
                      if (_errorText1 == null) {
                        record.readings = value1.toString();
                        _saveReadings();
                        Navigator.pop(context);
                      }
                    }
                  },
                ),
              ],
            );
          });
        });
  }

  Future<void> _saveReadings() async {
    setState(() {
      _isLoading = true;
    });
    try {
      //await Provider.of<XXXX>(context, listen: false)
      //    .updateReadings(_reading.id!, _reading);
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => const SimpleDialogue(
            header: 'An error occurred!',
            text: 'Changes not saved.  Please retry.'),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }
}
