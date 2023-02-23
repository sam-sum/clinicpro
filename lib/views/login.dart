import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clinicpro/utilities/screen_size.dart';
import 'package:clinicpro/utilities/styles.dart';
import 'package:clinicpro/widgets/stateless_button.dart';
import 'package:clinicpro/widgets/bottom_nav.dart';
import 'package:clinicpro/assets/constants.dart' as constants;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey globalKey = GlobalKey();
  final _accessCodeController = TextEditingController();
  bool _submitted = false;
  String valueName = constants.ADMIN;
  String? get _errorText {
    // at any time, we can get the text from _controller.value.text
    final text = _accessCodeController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length < 4) {
      return 'Too short';
    }
    // return null if the text is valid
    return null;
  }

  @override
  void dispose() {
    _accessCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    return SafeArea(
      child: Material(
        color: Styles.whiteColor,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: getProrataHeight(100)),
              const Image(
                image: AssetImage('assets/images/clinicpro_logo.png'),
                width: 200,
                height: 200,
              ),
              SizedBox(height: getProrataHeight(20)),
              Text(
                'Clinic Pro',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: getProrataWidth(17),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: getProrataHeight(90)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getProrataWidth(50)),
                child: Column(
                  children: [
                    // user name input field
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Your Name',
                        filled: true,
                        fillColor: Styles.greyColor,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(getProrataWidth(8)),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        valueName = value;
                      },
                      onTap: () async {
                        await Future.delayed(const Duration(milliseconds: 500));
                        RenderObject? object =
                            globalKey.currentContext?.findRenderObject();
                        object?.showOnScreen();
                      },
                    ),
                    SizedBox(height: getProrataHeight(20)),
                    ValueListenableBuilder(
                      valueListenable: _accessCodeController,
                      builder: (BuildContext context, TextEditingValue value,
                          Widget? child) {
                        // password input field
                        return TextField(
                          controller: _accessCodeController,
                          decoration: InputDecoration(
                            errorText: _submitted ? _errorText : null,
                            hintText: 'Your Access Code',
                            filled: true,
                            fillColor: Styles.greyColor,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(getProrataWidth(8)),
                              borderSide: const BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          onTap: () async {
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            RenderObject? object =
                                globalKey.currentContext?.findRenderObject();
                            object?.showOnScreen();
                          },
                        );
                      },
                    ),
                    StatelessButton(
                      buttonText: 'Continue',
                      onPressed: () async {
                        setState(() => _submitted = true);
                        if (_errorText == null) {
                          valueName =
                              (valueName.isEmpty) ? constants.ADMIN : valueName;
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString(constants.LOGIN_USER, valueName);
                          if (context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, BottomNav.routeName, (_) => false);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),

              // The globalKey of the SizedBox can force the screen scroll up when the soft keyboard appears
              SizedBox(key: globalKey, height: getProrataHeight(300)),
            ],
          ),
        ),
      ),
    );
  }
}
