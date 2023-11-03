// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:killeradmin/Productos/productos.dart';

import '../global/responsive.dart';
import '../global/side_menu.dart';

class MainProductos extends StatefulWidget {
  const MainProductos({Key? key}) : super(key: key);

  @override
  _MainProductosState createState() => _MainProductosState();
}

class _MainProductosState extends State<MainProductos> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: const Productos(),
        tablet: const Row(
          children: [
            Expanded(
              flex: 6,
              child: Productos(),
            ),
          ],
        ),
        desktop: Row(
          children: [
            Expanded(
              flex: size.width > 1340 ? 1 : 2,
              child: const SideMenu(),
            ),
            Expanded(
              flex: size.width > 1340 ? 8 : 10,
              child: const Productos(),
            ),
          ],
        ),
        key: null,
      ),
    );
  }
}
