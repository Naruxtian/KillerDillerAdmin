// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:killeradmin/Pedidos/pedidos.dart';

import '../global/responsive.dart';
import '../global/side_menu.dart';

class MainPedidos extends StatefulWidget {
  const MainPedidos({Key? key}) : super(key: key);

  @override
  _MainPedidosState createState() => _MainPedidosState();
}

class _MainPedidosState extends State<MainPedidos> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: const Pedidos(),
        tablet: const Row(
          children: [
            Expanded(
              flex: 6,
              child: Pedidos(),
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
              child: const Pedidos(),
            ),
          ],
        ),
        key: null,
      ),
    );
  }
}
