// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:killeradmin/Eventos/eventos.dart';

import '../global/responsive.dart';
import '../global/side_menu.dart';

class MainEventos extends StatefulWidget {
  const MainEventos({Key? key}) : super(key: key);

  @override
  _MainEventosState createState() => _MainEventosState();
}

class _MainEventosState extends State<MainEventos> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: const Eventos(),
        tablet: const Row(
          children: [
            Expanded(
              flex: 6,
              child: Eventos(),
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
              child: const Eventos(),
            ),
          ],
        ),
        key: null,
      ),
    );
  }
}
