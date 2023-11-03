// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:killeradmin/Clientes/clientes.dart';

import '../global/responsive.dart';
import '../global/side_menu.dart';

class MainClientes extends StatefulWidget {
  const MainClientes({Key? key}) : super(key: key);

  @override
  _MainClientesState createState() => _MainClientesState();
}

class _MainClientesState extends State<MainClientes> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: const Clientes(),
        tablet: const Row(
          children: [
            Expanded(
              flex: 6,
              child: Clientes(),
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
              child: const Clientes(),
            ),
          ],
        ),
        //key: null,
      ),
    );
  }
}
