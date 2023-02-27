import 'package:clinicpro/providers/vital_signs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:clinicpro/utilities/styles.dart';
import 'package:clinicpro/models/patient_model.dart';
import 'package:provider/provider.dart';
import '../models/vital_sign_latest_model.dart';
import '../providers/patients.dart';
import '../widgets/simple_dialogue.dart';
import '../widgets/stateless_button.dart';
import 'medical_records.dart';

class PatientDetails extends StatefulWidget {
  const PatientDetails({Key? key}) : super(key: key);

  static const routeName = '/patientDetails';

  @override
  State<PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  late Patient _patient;
  // Use with _displayNameInputDialog
  late TextEditingController _firstNameFieldController;
  late TextEditingController _lastNameFieldController;
  late TextEditingController _doctorFieldController;
  String? valueFirstName;
  String? valueLastName;
  String? valueDoctor;
  // Use with _displayNoteInputDialog
  late TextEditingController _noteFieldController;
  String? valueNote;
  //Use with _displayContactInputDialog
  late TextEditingController _addressFieldController;
  late TextEditingController _postalCodeFieldController;
  late TextEditingController _phoneFieldController;
  String? valueAddress;
  String? valuePostalCode;
  int? valuePhone;

  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    _patient = ModalRoute.of(context)!.settings.arguments as Patient;

    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<VitalSigns>(context, listen: false)
          .fetchLatestVitalSignsForPatient(_patient)
          .catchError((error) {
        if (kDebugMode) {
          print('Get vital signs summary error: $error');
        }
        showDialog(
          context: context,
          builder: (ctx) => const SimpleDialogue(
              header: 'Network error!',
              text: 'Cannot get patient exam details.  Please retry.'),
        );
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _firstNameFieldController.dispose();
    _lastNameFieldController.dispose();
    _doctorFieldController.dispose();
    _noteFieldController.dispose();
    _addressFieldController.dispose();
    _postalCodeFieldController.dispose();
    _phoneFieldController.dispose();
    super.dispose();
  }

  Future<void> _displayNameInputDialog(BuildContext context) async {
    _firstNameFieldController =
        TextEditingController(text: _patient.firstName ?? '');
    _lastNameFieldController =
        TextEditingController(text: _patient.lastName ?? '');
    _doctorFieldController = TextEditingController(text: _patient.doctor ?? '');

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            title: const Center(child: Text('Edit Info')),
            titleTextStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            content: Builder(
              builder: (context) {
                var width = MediaQuery.of(context).size.width;
                return SizedBox(
                  width: width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              valueFirstName = value;
                            });
                          },
                          controller: _firstNameFieldController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                            labelText: "First Name",
                            fillColor: Colors.white70,
                            isDense: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              valueLastName = value;
                            });
                          },
                          controller: _lastNameFieldController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                            labelText: "Last Name",
                            fillColor: Colors.white70,
                            isDense: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              valueDoctor = value;
                            });
                          },
                          controller: _doctorFieldController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                            labelText: "Responsible Doctor",
                            fillColor: Colors.white70,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            actions: <Widget>[
              StatelessButton(
                width: 200,
                buttonText: 'Submit',
                onPressed: () {
                  setState(() {
                    _patient.firstName = valueFirstName ?? _patient.firstName;
                    _patient.lastName = valueLastName ?? _patient.lastName;
                    _patient.doctor = valueDoctor ?? _patient.doctor;
                    _savePatient();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Future<void> _displayNoteInputDialog(BuildContext context) async {
    _noteFieldController =
        TextEditingController(text: _patient.medicalNotes ?? '');

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            title: const Center(child: Text('Edit Notes')),
            titleTextStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            content: Builder(
              builder: (context) {
                var width = MediaQuery.of(context).size.width;
                return SizedBox(
                  width: width,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 10,
                      maxLines: null,
                      onChanged: (value) {
                        setState(() {
                          valueNote = value;
                        });
                      },
                      controller: _noteFieldController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor: Colors.white70,
                        isDense: true,
                      ),
                    ),
                  ),
                );
              },
            ),
            actions: <Widget>[
              StatelessButton(
                width: 200,
                buttonText: 'Submit',
                onPressed: () {
                  setState(() {
                    _patient.medicalNotes = valueNote ?? _patient.medicalNotes;
                    _savePatient();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Future<void> _displayContactInputDialog(BuildContext context) async {
    _addressFieldController =
        TextEditingController(text: _patient.address ?? '');
    _postalCodeFieldController =
        TextEditingController(text: _patient.postalCode ?? '');
    _phoneFieldController =
        TextEditingController(text: _patient.phoneNumber.toString());

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            title: const Center(child: Text('Edit Contact')),
            titleTextStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            content: Builder(
              builder: (context) {
                var width = MediaQuery.of(context).size.width;
                return SizedBox(
                  width: width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              valueAddress = value;
                            });
                          },
                          controller: _addressFieldController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                            labelText: "Address",
                            fillColor: Colors.white70,
                            isDense: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              valuePostalCode = value;
                            });
                          },
                          controller: _postalCodeFieldController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                            labelText: "Postal Code",
                            fillColor: Colors.white70,
                            isDense: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              try {
                                valuePhone = int.parse(value);
                              } catch (error) {
                                valuePhone = _patient.phoneNumber;
                              }
                            });
                          },
                          controller: _phoneFieldController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                            labelText: "Phone",
                            fillColor: Colors.white70,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            actions: <Widget>[
              StatelessButton(
                width: 200,
                buttonText: 'Submit',
                onPressed: () {
                  setState(() {
                    _patient.address = valueAddress ?? _patient.address;
                    _patient.postalCode =
                        valuePostalCode ?? _patient.postalCode;
                    _patient.phoneNumber = valuePhone ?? _patient.phoneNumber;
                    _savePatient();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Future<void> _savePatient() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Patients>(context, listen: false)
          .updatePatient(_patient.id!, _patient);
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

  @override
  Widget build(BuildContext context) {
    final VitalSignLatest summaryData =
        Provider.of<VitalSigns>(context).summary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.backgroundColor,
        title: Text(
          'Patient Details',
          style: TextStyle(
            color: Styles.blackColor,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : LayoutBuilder(builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
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
                                    margin:
                                        const EdgeInsets.fromLTRB(22, 5, 22, 5),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image(
                                        image: NetworkImage(_patient.photoUrl!),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                        _notesCard(context),
                        _examCard(context, summaryData),
                        _addressCard(context),
                      ],
                    ),
                  ),
                ),
              );
            }),
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
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text(
                    "Name: ${_patient.firstName} ${_patient.lastName}",
                  ),
                ),
              ),
              IconButton(
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                icon: const FaIcon(
                  FontAwesomeIcons.pencil,
                  size: 15,
                ),
                onPressed: () {
                  _displayNameInputDialog(context);
                },
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

  Widget _notesCard(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.fromLTRB(25, 12, 25, 12),
        elevation: 10.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 12, 10, 5),
                  child: Text(
                    "Medical Notes",
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
                  icon: const FaIcon(
                    FontAwesomeIcons.pencil,
                    size: 15,
                  ),
                  onPressed: () {
                    _displayNoteInputDialog(context);
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 12),
              child: Text(_patient.medicalNotes ?? 'No record'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _examCard(BuildContext context, VitalSignLatest summaryData) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.fromLTRB(25, 12, 25, 12),
      elevation: 10.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                child: Text(
                  "Blood Pressure: ${summaryData.bloodPressure ?? 'No Record'}",
                ),
              ),
              IconButton(
                padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
                icon: const FaIcon(
                  FontAwesomeIcons.solidRectangleList,
                  size: 15,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    MedicalRecords.routeName,
                    arguments: _patient,
                  );
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 12),
            child: Text(
              "Blood Oxygen Level: ${summaryData.bloodOxygenLevel ?? 'No Record'}",
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 12),
            child: Text(
              "Respiratory Rate: ${summaryData.respiratoryRate ?? 'No Record'}",
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 12),
            child: Text(
              "Heart Beat Rate: ${summaryData.heartBeatRate ?? 'No Record'}",
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.fromLTRB(25, 12, 25, 12),
      elevation: 10.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                child: Text("Address: ${_patient.address ?? 'No record'}"),
              ),
              IconButton(
                padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
                icon: const FaIcon(
                  FontAwesomeIcons.pencil,
                  size: 15,
                ),
                onPressed: () {
                  _displayContactInputDialog(context);
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
            child: Text("Postal Code: ${_patient.postalCode ?? 'No record'}"),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
            child: Text("Phone: ${_patient.phoneNumber ?? 'No record'}"),
          ),
        ],
      ),
    );
  }
}
