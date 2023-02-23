import 'package:clinicpro/views/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:clinicpro/utilities/styles.dart';
import 'package:clinicpro/models/patient_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/Patients.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var _isInit = true;
  var _isLoading = false;

  List<Patient> patientList = [];

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
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: patientList.length,
                          itemBuilder: ((context, index) {
                            var item = patientList[index];
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
