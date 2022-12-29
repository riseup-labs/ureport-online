import 'package:flutter/material.dart';

Widget submitButton({
  required String type,
  required Function() onPressed,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    margin: EdgeInsets.only(left: 10),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: type == 'google'
            ? Colors.red
            : type == 'facebook'
                ? Color(0xff3B5998)
                : type == 'apple'
                    ? Colors.black
                    : Color.fromRGBO(68, 151, 223, 1),
        foregroundColor: type == 'google' ? Colors.black : Colors.white,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          type == 'login' || type == 'register'
              ? SizedBox()
              : Image(
                  image: AssetImage(type == "google"
                      ? 'assets/images/google-logo.png'
                      : type == "facebook"
                          ? 'assets/images/facebook-logo.png'
                          : 'assets/images/apple-logo.png'),
                  color: Colors.white,
                  height: 14.0,
                ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              type == "google"
                  ? 'Google'
                  : type == "facebook"
                      ? 'Facebook'
                      : type == 'apple'
                          ? 'Apple'
                          : type == 'login'
                              ? 'AUTENTIFICĂ-TE'
                              : 'CREEAZĂ CONT',
              style: TextStyle(
                fontWeight: type == 'login' || type == 'register'
                    ? FontWeight.w700
                    : FontWeight.w400,
                fontSize: type == 'login' || type == 'register' ? 16 : 14,
                color: type == 'login' || type == 'register'
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget textField({
  required String label,
  required TextEditingController controller,
  String? errorText,
  required bool obscureText,
  required TextInputType keyboardType,
  required TextInputAction textInputAction,
}) {
  return Container(
    padding: EdgeInsets.all(15),
    margin: EdgeInsets.only(right: 30, left: 30, top: 10),
    child: Column(
      children: [
        Container(
            margin: EdgeInsets.only(bottom: 5),
            width: double.infinity,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            )),
        Theme(
          data: ThemeData(
              textSelectionTheme: TextSelectionThemeData(
            selectionColor: Colors.grey,
            selectionHandleColor: Colors.black,
          )),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            cursorColor: Colors.black,
            textInputAction: textInputAction,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black,
                ),
              ),
              errorText: errorText,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black45,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black45,
                ),
                borderRadius: BorderRadius.circular(25.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

void showPopup({
  required BuildContext context,
  String? type,
  String? message,
  required Function() onPressed,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('U-Report'),
        content: message == null
            ? Text(type == 'register'
                ? 'Contul tău a fost creat cu succes. De acum poți avea acces la toate articolele din aplicație și poți câștiga puncte dacă ești un uReporter conștiincios! '
                : type == 'pwrecover'
                    ? "Ai primit pe email modalitatea de resetare a parolei!"
                    : 'Ai fost autentificat cu succes!')
            : Text(message),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(68, 151, 223, 1),
            ),
            child: const Text(
              'Continuă',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: onPressed,
          ),
        ],
      );
    },
  );
}
