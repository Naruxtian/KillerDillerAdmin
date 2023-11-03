// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:killeradmin/global/responsive.dart';

import '../global/side_menu.dart';
import '../global/style_principal.dart';

class MenuVista extends StatefulWidget {
  const MenuVista({Key? key}) : super(key: key);

  @override
  _MenuVistaState createState() => _MenuVistaState();
}

final GlobalKey<ScaffoldState> _menuKey = GlobalKey<ScaffoldState>();

class _MenuVistaState extends State<MenuVista> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _menuKey,
      appBar: AppBar(
        leading: !Responsive.isDesktop(context)
            ? IconButton(
                icon: const FaIcon(FontAwesomeIcons.barsStaggered,
                    color: Colors.black, size: 20),
                onPressed: () {
                  _menuKey.currentState?.openDrawer();
                },
              )
            : const SizedBox(),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
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
                "INICIO",
                style: stylePrincipalBold(20, Colors.black),
              ),
            ],
          ),
        ),
      ),
      drawer: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 250),
        child: const SideMenu(),
      ),
      body: Container(
          height: size.height,
          width: size.width,
          color: Colors.white,
          child: Responsive.isDesktop(context)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "lib/assets/menu.gif",
                      fit: BoxFit.cover,
                      height: size.height * 0.7,
                    ),
                    Text(
                      "//02",
                      style: stylePrincipalBold(40, Colors.black),
                    ),
                    VerticalDivider(
                      color: Colors.black,
                      width: size.width * 0.1,
                      thickness: 5,
                      indent: size.height * 0.3,
                      endIndent: 20,
                    )
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "//02",
                      style: stylePrincipalBold(40, Colors.black),
                    ),
                    Image.asset(
                      "lib/assets/menu.gif",
                      fit: BoxFit.cover,
                      height: size.height * 0.7,
                    ),
                  ],
                )),
    );
  }
}
