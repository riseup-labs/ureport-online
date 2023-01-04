import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/account/login-register/login_register_widgets.dart';
import 'package:ureport_ecaro/all-screens/home/articles/shared/top_header_widget.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final currentPwController = TextEditingController();
  final newPwController = TextEditingController();
  final confirmNewPwController = TextEditingController();

  var _pwError;
  var _newPwError;
  var _confNewPwError;

  Future<void> changePassword() async {
    User user = FirebaseAuth.instance.currentUser!;

    await user
        .reauthenticateWithCredential(EmailAuthProvider.credential(
            email: user.email!, password: currentPwController.text))
        .then((value) {
      user.updatePassword(newPwController.text);
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopHeaderWidget(title: "Parolă"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "Schimbă parola",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Pentru a schimba parola este necesar să introduci parola curentă înainte de a completa o nouă parolă pentru contul tău.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 20,
              ),
              textField(
                label: "Parolă curentă",
                controller: currentPwController,
                obscureText: false,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                errorText: _pwError,
              ),
              SizedBox(
                height: 30,
              ),
              textField(
                label: "Parolă nouă",
                controller: newPwController,
                obscureText: false,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                errorText: _newPwError,
              ),
              textField(
                label: "Confirmă parolă nouă",
                controller: confirmNewPwController,
                obscureText: false,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                errorText: _confNewPwError,
              ),
              Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(right: 16, left: 16, top: 20),
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(167, 45, 111, 1),
                    ),
                    child: Text(
                      "Confirmare",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: (() {
                      setState(() {
                        if (currentPwController.text.isEmpty) {
                          _pwError = "Parola nu poate fi goală";
                        } else {
                          _pwError = null;
                        }
                        if (newPwController.text.isEmpty) {
                          _newPwError = "Parola nu poate fi goală";
                        } else {
                          _newPwError = null;
                        }
                        if (confirmNewPwController.text.isEmpty) {
                          _confNewPwError = "Parola nu poate fi goală";
                        } else {
                          _confNewPwError = null;
                        }
                        if (newPwController.text !=
                            confirmNewPwController.text) {
                          _confNewPwError = "Parolele nu se potrivesc";
                        } else {
                          _confNewPwError = null;
                        }
                      });
                      changePassword();
                    }),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
