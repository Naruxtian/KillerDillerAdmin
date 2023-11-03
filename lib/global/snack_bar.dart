import 'package:flutter/material.dart';
import 'package:killeradmin/global/responsive.dart';
import 'package:killeradmin/global/style_principal.dart';

snackbarW(
    Size size, BuildContext context, String title, IconData icon, Color color) {
  final snackBar = SnackBar(
    content: Container(
      //color: Colors.white,
      height: size.height * 0.1,
      width:
          Responsive.isDesktop(context) ? size.width * 0.35 : size.width * 0.5,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(14)),
      margin: EdgeInsets.fromLTRB(
          Responsive.isDesktop(context) ? size.width * 0.8 : size.width * 0.4,
          0,
          0,
          15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              title,
              style: stylePrincipalBold(13, Colors.grey),
            ),
            Icon(icon, color: color, size: 22)
          ],
        ),
      ),
    ),
    backgroundColor: Colors.transparent,
    elevation: 1000,
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
