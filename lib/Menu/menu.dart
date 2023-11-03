// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:killeradmin/Menu/menu_vista.dart';

import '../global/responsive.dart';
import '../global/side_menu.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: const MenuVista(),
        tablet: const Row(
          children: [
            Expanded(
              flex: 6,
              child: MenuVista(),
            ),
          ],
        ),
        desktop: Row(
          children: [
            Expanded(
              flex: _size.width > 1340 ? 1 : 2,
              child: const SideMenu(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 8 : 10,
              child: const MenuVista(),
            ),
          ],
        ),
        key: null,
      ),
    );
  }
}
