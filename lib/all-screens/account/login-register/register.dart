import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/account/login-register/login.dart';
import 'package:ureport_ecaro/all-screens/account/login-register/login_register_widgets.dart';
import 'package:ureport_ecaro/all-screens/home/articles/shared/top_header_widget.dart';
import 'package:ureport_ecaro/all-screens/home/navigation-screen.dart';
import 'package:ureport_ecaro/utils/firebase_apis.dart';

import 'package:ureport_ecaro/utils/nav_utils.dart';
import 'package:ureport_ecaro/utils/top_bar_background.dart';
import 'package:validators/validators.dart' as validator;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwdController = TextEditingController();
  final _confirmPwController = TextEditingController();

  var _emailError;
  var _passwordError;
  var _confirmPwError;
  var _nameError;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Column(children: [
        TopHeaderWidget(title: "ÎNREGISTRARE"),
        Container(
            margin: EdgeInsets.only(top: 80, left: 10),
            width: double.infinity,
            child: Text(
              "CREAZĂ-ȚI UN CONT",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                  fontFamily: 'Heebo'),
            )),
        Container(
          width: double.infinity,
          height: 40,
          margin: EdgeInsets.only(right: 30, left: 30, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: submitButton(
                    type: 'google',
                    onPressed: () {
                      print("google");
                    }),
              ),
              Expanded(
                child: submitButton(
                    type: 'facebook',
                    onPressed: () {
                      print("facebook");
                    }),
              ),
            ],
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: 30),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 100,
                    child: Divider(
                      color: Colors.black,
                    )),
                Text("SAU"),
                Container(
                    width: 100,
                    child: Divider(
                      color: Colors.black,
                    )),
              ],
            )),
        textField(
          label: "Nume și prenume",
          textInputAction: TextInputAction.next,
          obscureText: false,
          keyboardType: TextInputType.name,
          controller: _nameController,
          errorText: _nameError,
        ),
        textField(
          label: "Email",
          textInputAction: TextInputAction.next,
          obscureText: false,
          keyboardType: TextInputType.emailAddress,
          controller: _emailController,
          errorText: _emailError,
        ),
        textField(
          label: "Password",
          textInputAction: TextInputAction.next,
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          controller: _passwdController,
          errorText: _passwordError,
        ),
        textField(
          label: "Confirmă parola",
          textInputAction: TextInputAction.done,
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          controller: _confirmPwController,
          errorText: _confirmPwError,
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(right: 16, left: 16, top: 20),
          height: 44,
          child: _isLoading
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                )
              : submitButton(
                  type: 'register', onPressed: () async => await register()),
        ),
        SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () => NavUtils.pushAndRemoveUntil(context, LoginScreen()),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              text: 'Ai deja cont? ',
              children: const <TextSpan>[
                TextSpan(
                    text: 'Autentifică-te',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue)),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ]),
    )));
  }

  void toggleIsLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  Future<void> register() async {
    if (_nameController.text.isEmpty || _nameController.text.length < 3) {
      setState(() {
        _nameError = "Numele este prea scurt";
      });
      return;
    } else {
      setState(() {
        _nameError = null;
      });
    }

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

    if (_passwdController.text.length < 6) {
      setState(() {
        _passwordError = "Parola este prea scurtă";
      });
      return;
    } else {
      setState(() {
        _passwordError = null;
      });
    }
    if (_passwdController.text != _confirmPwController.text) {
      setState(() {
        _confirmPwError = "Parolele nu se potrivesc";
      });
      return;
    } else {
      setState(() {
        _confirmPwError = null;
      });
    }
    toggleIsLoading();

    final registerResult = await FirebaseApis().register(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwdController.text,
    );
    if (registerResult == RegisterStatus.SUCCESS) {
      toggleIsLoading();

      showPopup(
          context: context,
          type: 'register',
          onPressed: () {
            NavUtils.pushAndRemoveUntil(context, NavigationScreen(0, 'ro'));
          });
    } else if (registerResult == RegisterStatus.EMAIL_EXISTS) {
      toggleIsLoading();
      showPopup(
          context: context,
          message: "Contul acesta deja exista",
          type: 'error',
          onPressed: () {
            Navigator.pop(context);
          });
    } else {
      toggleIsLoading();
      showPopup(
          context: context,
          message: "S-a produs o eroare",
          type: 'error',
          onPressed: () {
            Navigator.pop(context);
          });
    }
  }
}
