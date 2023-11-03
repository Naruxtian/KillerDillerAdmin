import 'package:flutter/material.dart';
import 'package:killeradmin/global/responsive.dart';
import 'package:killeradmin/global/style_principal.dart';

bottonGeneric(Size size, String title, VoidCallback action, Color color,
    BuildContext context) {
  return InkWell(
    onTap: action,
    child: Container(
      height: size.height * 0.06,
      width:
          Responsive.isDesktop(context) ? size.width * 0.2 : size.width * 0.3,
      margin: const EdgeInsets.all(10),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(20), color: color),
      child: Center(
        child: Text(title, style: stylePrincipalBold(14, Colors.white)),
      ),
    ),
  );
}
