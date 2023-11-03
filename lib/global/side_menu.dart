// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:killeradmin/Clientes/clientes_main.dart';
import 'package:killeradmin/Eventos/main_eventos.dart';
import 'package:killeradmin/Pedidos/main_pedidos.dart';
import 'package:killeradmin/Productos/main_productos.dart';
import 'package:killeradmin/global/generic_button.dart';
import 'package:killeradmin/global/responsive.dart';
import 'package:killeradmin/global/style_principal.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

String selected = "";

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.only(top: 10),
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage("lib/assets/logoKd.jpg"),
                ),
                const SizedBox(
                  height: 20,
                ),
                menuItem(FontAwesomeIcons.cartFlatbed, "Productos", size),
                menuItem(FontAwesomeIcons.peopleGroup, "Clientes", size),
                menuItemBadge(FontAwesomeIcons.folderTree, "Pedidos", size),
                menuItem(FontAwesomeIcons.calendar, "Eventos", size),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: size.height * 0.2,
                  width: 3,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 20,
                ),
                menuItem(
                    FontAwesomeIcons.rightFromBracket, "Cerrar SESIÓN", size),
              ]),
        ),
      ),
    );
  }

  cerrarSesion(Size size) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
                width: size.width,
                color: Colors.transparent,
                child: Padding(
                    padding: Responsive.isDesktop(context)
                        ? const EdgeInsets.fromLTRB(350, 0, 150, 0)
                        : const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        color: Colors.white,
                      ),
                      height: size.height * 0.2,
                      width: size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "¿Estas seguro de cerrar la sesiÓn?",
                            style: stylePrincipalBold(16, Colors.grey),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              bottonGeneric(size, "Confirmar", () {
                                FirebaseAuth.instance.signOut();
                                Navigator.of(context).pop();
                              }, Colors.black, context),
                              const SizedBox(
                                width: 10,
                              ),
                              bottonGeneric(size, "Cancelar", () {
                                Navigator.of(context).pop();
                              }, Colors.black, context)
                            ],
                          )
                        ],
                      ),
                    )));
          });
        });
  }

  Widget menuItem(IconData icon, String title, Size size) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = title;
          if (selected == "Clientes") {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    const MainClientes(),
                transitionDuration: Duration.zero,
              ),
            );
          } else if (selected == "Pedidos") {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    const MainPedidos(),
                transitionDuration: Duration.zero,
              ),
            );
          } else if (selected == "Eventos") {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    const MainEventos(),
                transitionDuration: Duration.zero,
              ),
            );
          } else if (selected == "Productos") {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    const MainProductos(),
                transitionDuration: Duration.zero,
              ),
            );
          } else {
            cerrarSesion(size);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(top: 15, bottom: 15),
        child: Column(
          children: [
            FaIcon(
              icon,
              size: 20,
              color: selected == title ? Colors.grey : Colors.black,
            ),
            const SizedBox(
              height: 8,
            ),
            selected == title
                ? Text(
                    title,
                    style: stylePrincipalBold(12, Colors.black),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  Widget menuItemBadge(IconData icon, String title, Size size) {
    return GestureDetector(
      onTap: () {
        selected = title;
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                const MainPedidos(),
            transitionDuration: Duration.zero,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 15, bottom: 15),
        child: Column(
          children: [
            IconBadge(
              icon: Icon(
                icon,
                size: 20,
                color: selected == title ? Colors.grey : Colors.black,
              ),
              itemCount: 8,
              badgeColor: Colors.red,
              itemColor: Colors.white,
              hideZero: true,
            ),
            const SizedBox(
              height: 8,
            ),
            selected == title
                ? Text(
                    title,
                    style: stylePrincipalBold(12, Colors.black),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
