import 'package:flutter/material.dart';
import 'package:killeradmin/global/style_principal.dart';

Widget appbar(Size size, String titulo, BuildContext context) {
  return AppBar(
    backgroundColor: Colors.white,
    automaticallyImplyLeading: false,
    title: Container(
      height: size.height * 0.1,
      width: size.width,
      padding: const EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            titulo,
            style: stylePrincipalBold(15, Colors.black),
          ),
        ],
      ),
    ),
  );
}
