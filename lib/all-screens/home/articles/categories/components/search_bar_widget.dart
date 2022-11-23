import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    Key? key,
    required this.onSearchChanged,
  }) : super(key: key);

  final Function(String value)? onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      height: 80,
      width: MediaQuery.of(context).size.width,
      child: TextField(
        onChanged: onSearchChanged,
        onEditingComplete: () {},
        decoration: InputDecoration(
          hintText: "Caută",
          hintStyle: TextStyle(fontSize: 16, color: Colors.black),
          filled: true,
          fillColor: Color.fromRGBO(217, 217, 217, 1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
