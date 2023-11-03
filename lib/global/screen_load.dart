import 'package:flutter/material.dart';

Widget screenLoad(Size size) {
  return Center(
    child: Container(
      height: size.height * 0.5,
      width: size.width * 0.5,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                "lib/assets/loadkd.gif",
              ),
              scale: 2,
              fit: BoxFit.scaleDown)),
    ),
  );
}
