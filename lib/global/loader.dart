import 'package:flutter/material.dart';

loader(BuildContext context, Size size) {
  showDialog(
      context: context,
      builder: (context) => Container(
            height: size.height * 0.2,
            width: size.width * 0.2,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "lib/assets/loadkd.gif",
                    ),
                    scale: 2,
                    fit: BoxFit.scaleDown)),
          ));
}
