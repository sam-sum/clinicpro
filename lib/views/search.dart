import 'package:clinicpro/views/patient_details.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:clinicpro/utilities/styles.dart';
import 'package:clinicpro/models/patient_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/Patients.dart';
import '../widgets/simple_dialogue.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var _isInit = true;
  var _isLoading = false;

  List<Patient> patientList = [];
  List<Patient> filterPatientList = [];

  TextEditingController _firstNameFieldController = TextEditingController();
  TextEditingController _lastNameFieldController = TextEditingController();
  TextEditingController _patientIdFieldController = TextEditingController();
  var _controller = TextEditingController();

  String? _firstNameField;
  String? _lastNameField;
  String? _patientIdField;

  @override
  void initState() {
    super.initState();
    _firstNameFieldController.addListener(() {
      _firstNameField = _firstNameFieldController.text;
      filterPatient();
      setState(() {});
    });
    _lastNameFieldController.addListener(() {
      _lastNameField = _lastNameFieldController.text;
      filterPatient();
      setState(() {});
    });
    _patientIdFieldController.addListener(() {
      _patientIdField = _patientIdFieldController.text;
      filterPatient();
      setState(() {});
    });
    _controller.addListener(() {
      _controller.text = '';
      filterPatient();
      setState(() {});
    });
  }

  void filterPatient() {
    filterPatientList = patientList;
    if (_firstNameField != null && _firstNameField!.isNotEmpty)
      filterPatientList = filterPatientList
          .where((element) => element.firstName!
              .toLowerCase()
              .contains(_firstNameField!.toLowerCase()))
          .toList();
    if (_lastNameField != null && _lastNameField!.isNotEmpty)
      filterPatientList = filterPatientList
          .where((element) => element.lastName!
              .toLowerCase()
              .contains(_lastNameField!.toLowerCase()))
          .toList();
    if (_patientIdField != null && _patientIdField!.isNotEmpty)
      filterPatientList = filterPatientList
          .where((element) => element.idCardNumber!
              .toLowerCase()
              .contains(_patientIdField!.toLowerCase()))
          .toList();
  }

  @override
  void dispose() {
    _firstNameFieldController.dispose();
    _lastNameFieldController.dispose();
    _patientIdFieldController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Patients>(context).fetchAllPatients().catchError((error) {
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
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //final patientsData = Provider.of<Patients>(context);
    patientList = Provider.of<Patients>(context).patients;
    filterPatient();

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
                    TextField(
                      controller: _firstNameFieldController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).disabledColor,
                          size: 25.0,
                        ),
                        suffixIcon: Visibility(
                          visible: _firstNameField != null &&
                              _firstNameField!.isNotEmpty,
                          child: IconButton(
                            onPressed: () {
                              _firstNameFieldController.clear();
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.solidCircleXmark,
                              size: 20,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        isDense: true,
                        hintText: 'First Name',
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: _lastNameFieldController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).disabledColor,
                          size: 25.0,
                        ),
                        suffixIcon: Visibility(
                          visible: _lastNameField != null &&
                              _lastNameField!.isNotEmpty,
                          child: IconButton(
                            onPressed: () {
                              _lastNameFieldController.clear();
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.solidCircleXmark,
                              size: 20,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        isDense: true,
                        hintText: 'Last Name',
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: _patientIdFieldController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).disabledColor,
                          size: 25.0,
                        ),
                        suffixIcon: Visibility(
                          visible: _patientIdField != null &&
                              _patientIdField!.isNotEmpty,
                          child: IconButton(
                            onPressed: () {
                              _patientIdFieldController.clear();
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.solidCircleXmark,
                              size: 20,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        isDense: true,
                        hintText: 'Patient\'s ID',
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: filterPatientList.length,
                          itemBuilder: ((context, index) {
                            var item = filterPatientList[index];
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
}
