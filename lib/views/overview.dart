import 'package:clinicpro/views/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:clinicpro/utilities/styles.dart';
import 'package:clinicpro/models/patient_model.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../assets/enum_filter_op.dart';
import '../assets/enum_gender_selection.dart';
import '../providers/patients.dart';
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

  final TextEditingController _upperPressureFieldController =
      TextEditingController();
  final TextEditingController _lowerPressureFieldController =
      TextEditingController();
  final TextEditingController _oxygenLevelFieldController =
      TextEditingController();
  final TextEditingController _respiratoryRateFieldController =
      TextEditingController();
  final TextEditingController _heartBeatRateFieldController =
      TextEditingController();

  List<Patient> _filteredPatients = [];
  List<Patient> _patients = [];

  List<DropdownMenuItem<FilterOp>> get _dropFilterOp {
    List<DropdownMenuItem<FilterOp>> menuItems = [
      const DropdownMenuItem(
          value: FilterOp.greater, child: Text("Greater Than")),
      const DropdownMenuItem(value: FilterOp.equal, child: Text("Equal")),
      const DropdownMenuItem(value: FilterOp.less, child: Text("Less Than")),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<FilterGender>> get _dropFilterGender {
    List<DropdownMenuItem<FilterGender>> menuItems = [
      const DropdownMenuItem(value: FilterGender.both, child: Text("Both")),
      const DropdownMenuItem(value: FilterGender.male, child: Text("Male")),
      const DropdownMenuItem(value: FilterGender.female, child: Text("Female")),
    ];
    return menuItems;
  }

  FilterOp _opUpperPressure = FilterOp.greater;
  FilterOp _opLowerPressure = FilterOp.greater;
  FilterOp _opOxygenLevel = FilterOp.greater;
  FilterOp _opRespiratoryRate = FilterOp.greater;
  FilterOp _opHeartBeatRate = FilterOp.greater;
  FilterGender _gender = FilterGender.both;

  bool checkFilter() {
    return !(_upperPressureFieldController.text.isEmpty &&
        _lowerPressureFieldController.text.isEmpty &&
        _oxygenLevelFieldController.text.isEmpty &&
        _respiratoryRateFieldController.text.isEmpty &&
        _heartBeatRateFieldController.text.isEmpty);
  }

  void clearFilter() {
    _upperPressureFieldController.text = '';
    _lowerPressureFieldController.text = '';
    _oxygenLevelFieldController.text = '';
    _respiratoryRateFieldController.text = '';
    _heartBeatRateFieldController.text = '';
    _opUpperPressure = FilterOp.greater;
    _opLowerPressure = FilterOp.greater;
    _opOxygenLevel = FilterOp.greater;
    _opRespiratoryRate = FilterOp.greater;
    _opHeartBeatRate = FilterOp.greater;
    _gender = FilterGender.both;
    setState(() {});
  }

  @override
  Future<void> didChangeDependencies() async {
    await refreshRemoteData();
    super.didChangeDependencies();
  }

  Future<void> refreshRemoteData() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Patients>(context, listen: false)
          .fetchAllPatients()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
  }

  void getFilteredPatients() async {
    setState(() {
      _isLoading = true;
    });

    if (!checkFilter()) {
      _filteredPatients = _patients;
    } else {
      FilterOp opUpperPressure = _upperPressureFieldController.text.isEmpty
          ? FilterOp.nop
          : _opUpperPressure;
      FilterOp opLowerPressure = _lowerPressureFieldController.text.isEmpty
          ? FilterOp.nop
          : _opLowerPressure;
      FilterOp opOxygenLevel = _oxygenLevelFieldController.text.isEmpty
          ? FilterOp.nop
          : _opOxygenLevel;
      FilterOp opRespiratoryRate = _respiratoryRateFieldController.text.isEmpty
          ? FilterOp.nop
          : _opRespiratoryRate;
      FilterOp opHeartBeatRate = _heartBeatRateFieldController.text.isEmpty
          ? FilterOp.nop
          : _opHeartBeatRate;
      FilterGender gender = _gender;

      _filteredPatients = await Provider.of<Patients>(context, listen: false)
          .fetchPatientsWithFilters(
        opUpperPressure: opUpperPressure,
        upperPressure: int.tryParse(_upperPressureFieldController.text) ?? 0,
        opLowerPressure: opLowerPressure,
        lowerPressure: int.tryParse(_lowerPressureFieldController.text) ?? 0,
        opOxygenLevel: opOxygenLevel,
        oxygenLevel: int.tryParse(_oxygenLevelFieldController.text) ?? 0,
        opRespiratoryRate: opRespiratoryRate,
        respiratoryRate:
            int.tryParse(_respiratoryRateFieldController.text) ?? 0,
        opHeartBeatRate: opHeartBeatRate,
        heartBeatRate: int.tryParse(_heartBeatRateFieldController.text) ?? 0,
        gender: gender,
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _upperPressureFieldController.dispose();
    _lowerPressureFieldController.dispose();
    _oxygenLevelFieldController.dispose();
    _respiratoryRateFieldController.dispose();
    _heartBeatRateFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _patients = Provider.of<Patients>(context).patients;
    return Material(
        color: Styles.backgroundColor,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () {
                  _isInit = true;
                  return refreshRemoteData();
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          const Text(
                            'All Patient',
                            style: TextStyle(fontSize: 18),
                          ),
                          const Spacer(),
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
                                  return filterBottom(context);
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
                      const SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: checkFilter()
                                ? _filteredPatients.length
                                : _patients.length,
                            itemBuilder: ((context, index) {
                              var item = checkFilter()
                                  ? _filteredPatients[index]
                                  : _patients[index];
                              return InkWell(
                                onTap: () async {
                                  await Navigator.pushNamed(
                                      context, PatientDetails.routeName,
                                      arguments: item);
                                  _isInit = true;
                                  await refreshRemoteData();
                                },
                                child: Card(
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
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
                                                      BorderRadius.circular(
                                                          5.0),
                                                  child: Image.network(
                                                      item.photoUrl!,
                                                      errorBuilder: (context,
                                                          exception,
                                                          stackTrace) {
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
                                                    '${item.firstName!} ${item.lastName!}',
                                                  ),
                                                  Text(
                                                    'Gender : ${item.gender!}',
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const FaIcon(
                                                        FontAwesomeIcons
                                                            .addressCard,
                                                        size: 15,
                                                      ),
                                                      Text(
                                                        ' #${item.idCardNumber!}',
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
                                                  item.disabled == true
                                                      ? const FaIcon(
                                                          FontAwesomeIcons
                                                              .wheelchair,
                                                          size: 15,
                                                        )
                                                      : Container(),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const FaIcon(
                                                        FontAwesomeIcons.bed,
                                                        size: 15,
                                                      ),
                                                      Text(
                                                        ' ${item.bedNumber!.toUpperCase()}',
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            const Expanded(
                                              flex: 1,
                                              child: FaIcon(
                                                FontAwesomeIcons
                                                    .ellipsisVertical,
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
                ),
              ));
  }

  Widget filterBottom(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Upper Blood Pressure'),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<FilterOp>(
                      value: _opUpperPressure,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      onChanged: (FilterOp? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          _opUpperPressure = value!;
                        });
                      },
                      items: _dropFilterOp,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(1),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _upperPressureFieldController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                    ),
                  ),
                ],
              ),
              const Text('Lower Blood Pressure'),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<FilterOp>(
                      value: _opLowerPressure,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      onChanged: (FilterOp? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          _opLowerPressure = value!;
                        });
                      },
                      items: _dropFilterOp,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(1),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _lowerPressureFieldController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                    ),
                  ),
                ],
              ),
              const Text('Blood Oxygen Level'),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<FilterOp>(
                      value: _opOxygenLevel,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      onChanged: (FilterOp? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          _opOxygenLevel = value!;
                        });
                      },
                      items: _dropFilterOp,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(1),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _oxygenLevelFieldController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                    ),
                  ),
                ],
              ),
              const Text('Respiratory Rate'),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<FilterOp>(
                      value: _opRespiratoryRate,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      onChanged: (FilterOp? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          _opRespiratoryRate = value!;
                        });
                      },
                      items: _dropFilterOp,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(1),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _respiratoryRateFieldController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                    ),
                  ),
                ],
              ),
              const Text('Heart Beat Rate'),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<FilterOp>(
                      value: _opHeartBeatRate,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      onChanged: (FilterOp? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          _opHeartBeatRate = value!;
                        });
                      },
                      items: _dropFilterOp,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(1),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _heartBeatRateFieldController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                    ),
                  ),
                ],
              ),
              const Text('Gender'),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<FilterGender>(
                      value: _gender,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      onChanged: (FilterGender? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          _gender = value!;
                        });
                      },
                      items: _dropFilterGender,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(1),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: StatelessButton(
                      height: 40,
                      buttonText: 'Filter',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          getFilteredPatients();
                          Navigator.pop(context);
                        }
                      },
                      padding:
                          EdgeInsets.symmetric(vertical: getProrataHeight(0)),
                    ),
                  ),
                  checkFilter()
                      ? Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: StatelessButton(
                              height: 40,
                              buttonText: 'Reset',
                              onPressed: () {
                                setState(() {
                                  clearFilter();
                                  getFilteredPatients();
                                });
                                Navigator.pop(context);
                              },
                              padding: EdgeInsets.symmetric(
                                  vertical: getProrataHeight(0)),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
