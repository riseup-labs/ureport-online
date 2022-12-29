import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/account/login-register/login.dart';
import 'package:ureport_ecaro/all-screens/account/login-register/login_register_widgets.dart';
import 'package:ureport_ecaro/utils/firebase_apis.dart';
import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:validators/validators.dart' as validator;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  //final _codeController = TextEditingController();
  //final _newPwController = TextEditingController();
  //final _confirmPwController = TextEditingController();

  //var _pwError;
  //var _confirmPwError;
  var _emailError;
  // var _codeError;
  //bool _codeSent = false;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Image.asset(
                  'assets/images/top_header_ro.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 80, left: 10),
                width: double.infinity,
                child: Text(
                  "RECUPERARE CONT",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 28,
                      fontFamily: 'Heebo'),
                ),
              ),
              // _codeSent
              //     ? SizedBox()
              //     :

              textField(
                label: "Email",
                textInputAction: TextInputAction.done,
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                errorText: _emailError,
              ),
              // _codeSent
              //     ? textField(
              //         label: "Parola nouă",
              //         textInputAction: TextInputAction.next,
              //         obscureText: false,
              //         keyboardType: TextInputType.emailAddress,
              //         controller: _newPwController,
              //         errorText: _pwError,
              //       )
              //     : SizedBox(),
              // _codeSent
              //     ? textField(
              //         label: "Confirmare parolă nouă",
              //         textInputAction: TextInputAction.next,
              //         obscureText: false,
              //         keyboardType: TextInputType.emailAddress,
              //         controller: _confirmPwController,
              //         errorText: _confirmPwError,
              //       )
              //     : SizedBox(),
              // _codeSent
              //     ? textField(
              //         label: "Cod primit",
              //         textInputAction: TextInputAction.done,
              //         obscureText: true,
              //         keyboardType: TextInputType.visiblePassword,
              //         controller: _codeController,
              //         errorText: _codeError,
              //       )
              //     : SizedBox(),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(right: 16, left: 16, top: 20),
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(68, 151, 223, 1),
                  ),
                  child: Text(
                    "Trimite cod",
                    //_codeSent ? "Confirmare" : "Trimite cod",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () => sendForgotPassword(),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () =>
                    NavUtils.pushAndRemoveUntil(context, LoginScreen()),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    text: 'Ți-ai amintit parola? ',
                    children: const <TextSpan>[
                      TextSpan(
                          text: 'Autentifică-te',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void toggleIsLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  Future<void> sendForgotPassword() async {
    // if (_codeSent) {
    //   if (_newPwController.text.length < 6) {
    //     setState(() {
    //       _pwError = "Parola este prea scurtă";
    //     });
    //     return;
    //   } else {
    //     setState(() {
    //       _pwError = null;
    //     });
    //   }
    // if (_newPwController.text != _confirmPwController.text) {
    //   setState(() {
    //     _confirmPwError = "Parolele nu se potrivesc";
    //   });
    //   return;
    // } else {
    //   setState(() {
    //     _confirmPwError = null;
    //   });
    // }
    if (!validator.isEmail(_emailController.text)) {
      setState(() {
        _emailError = "Email invalid";
      });
      return;
    } else {
      setState(() {
        _emailError = null;
      });
    }
    toggleIsLoading();

    await FirebaseApis().resetPassword(
      email: _emailController.text,
    );

    showPopup(
        context: context,
        type: 'pwrecover',
        onPressed: () {
          NavUtils.pushAndRemoveUntil(context, LoginScreen());
        });
  }
}
