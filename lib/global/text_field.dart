import 'package:flutter/material.dart';
import 'package:killeradmin/global/style_principal.dart';

Widget customTextf(
    TextEditingController controller, String title, IconData icon) {
  return Container(
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15), color: Colors.white),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 20, color: Colors.black),
        hintStyle: stylePrincipalBold(14, Colors.grey),
        hintText: title,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 2.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 2.0),
        ),
      ),
      style: stylePrincipalBold(13, Colors.grey),
    ),
  );
}
