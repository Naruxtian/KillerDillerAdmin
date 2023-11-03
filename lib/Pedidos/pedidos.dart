// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages

import 'dart:convert';

import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:intl/intl.dart";
import 'package:killeradmin/Pedidos/components/detalles.dart';
import 'package:killeradmin/global/screen_load.dart';
import '../global/responsive.dart';
import '../global/side_menu.dart';
import '../global/style_principal.dart';
import '../services/http.dart';

class Pedidos extends StatefulWidget {
  const Pedidos({Key? key}) : super(key: key);

  @override
  _PedidosState createState() => _PedidosState();
}

final GlobalKey<ScaffoldState> _pedidosKey = GlobalKey<ScaffoldState>();

String buscador = "";
final _buscadorController = DropdownEditingController<String>();
List<dynamic> pedidos = [];

NumberFormat f = NumberFormat("#,##0.00", "es_US");

List<dynamic>? pedidosGet = [];

List<dynamic>? pedidoSelected = [];

bool isLoading = true;

class _PedidosState extends State<Pedidos> {
  @override
  void initState() {
    getPedidos();
    // getPedidos().whenComplete(() {
    //   Future.delayed(const Duration(seconds: 1), () {
    //     setState(() {
    //       isLoading = false;
    //     });
    //   });
    // });
    super.initState();
  }

  getPedidos() async {
    //urlServiceGet("usuario/admin/orders/getOrders");
    pedidosGet =
        jsonDecode(await urlServiceGet("usuario/admin/orders/getOrders"));
    //pedidos = pedidosGet!['orders'];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _pedidosKey,
      appBar: AppBar(
        leading: !Responsive.isDesktop(context)
            ? IconButton(
                icon: const FaIcon(FontAwesomeIcons.barsStaggered,
                    color: Colors.black, size: 20),
                onPressed: () {
                  _pedidosKey.currentState?.openDrawer();
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
                "Pedidos",
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
      endDrawer: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: Responsive.isDesktop(context)
              ? size.width * 0.3
              : size.width * 0.9,
        ),
        child: DetallesPedido(
          productos: pedidoSelected!,
        ),
      ),
      body: isLoading == true
          ? screenLoad(size)
          : Container(
              height: size.height,
              width: size.width,
              padding: const EdgeInsets.all(8),
              color: Colors.white,
              child: Column(
                children: [
                  Responsive.isDesktop(context)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "//05",
                              style: stylePrincipalBold(40, Colors.black),
                            ),
                            //buscadorW(size),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "//05",
                              style: stylePrincipalBold(40, Colors.black),
                            ),
                            //buscadorW(size),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                  Container(
                    height: Responsive.isDesktop(context)
                        ? size.height * 0.8
                        : size.height * .65,
                    width: size.width,
                    padding: const EdgeInsets.all(8),
                    child: Responsive.isDesktop(context)
                        ? GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, //columnas
                              mainAxisSpacing: 10.0, //espacio entre cards
                              crossAxisSpacing: 10,
                              childAspectRatio: 4, // largo de la card
                            ),
                            itemCount: pedidos.length,
                            itemBuilder: (BuildContext context, var index) {
                              return _buildCliente(size, index);
                            },
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: pedidos.length,
                            itemBuilder: (BuildContext context, var index) {
                              return _buildCliente(size, index);
                            },
                          ),
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildCliente(Size size, int ind) {
    List<dynamic> totalPrice = [];
    totalPrice = pedidos[ind]['products'];
    dynamic total = 0;
    for (var i in totalPrice) {
      total += i['price'];
    }

    return FocusedMenuHolder(
        menuWidth:
            Responsive.isDesktop(context) ? size.width * 0.2 : size.width * 0.8,
        blurSize: 5.0,
        menuItemExtent: 45,
        menuBoxDecoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        duration: const Duration(milliseconds: 100),
        animateMenuItems: true,
        blurBackgroundColor: Colors.black54,
        openWithTap: true, // Open Focused-Menu on Tap rather than Long Press
        menuOffset:
            10.0, // Offset value to show menuItem from the selected item
        bottomOffsetHeight:
            80.0, // Offset height to consider, for showing the menu item ( for example bottom navigation bar), so that the popup menu will be shown on top of selected item.
        menuItems: <FocusedMenuItem>[
          // Add Each FocusedMenuItem  for Menu Options
          FocusedMenuItem(
              title: Text(
                "Detalles de pedido",
                style: stylePrincipalBold(11, Colors.grey),
              ),
              trailingIcon: const Icon(FontAwesomeIcons.penToSquare,
                  color: Colors.orange, size: 20),
              onPressed: () {
                setState(() {
                  pedidoSelected = pedidos[ind]['products'];
                });
                _pedidosKey.currentState?.openEndDrawer();
              }),
        ],
        onPressed: () {},
        child: Container(
          height: size.height * 0.15,
          width: size.width,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage("lib/assets/pendientekd.png"),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    pedidos[ind]['user_id']['name'],
                    style: stylePrincipalBold(13, Colors.black),
                  ),
                  Text(
                    "costo - \$${f.format(total)}",
                    style: stylePrincipalBold(11, Colors.grey),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "productos: ${pedidos[ind]['total_products']}",
                        style: stylePrincipalBold(9, Colors.grey),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ));
  }

  Widget buscadorW(Size size) {
    return buscador == ""
        ? Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            height: size.height * 0.07,
            width: Responsive.isDesktop(context)
                ? size.width * 0.35
                : size.width * 0.6,
            child: TextDropdownFormField(
                onChanged: (dynamic item) {
                  setState(() {
                    buscador = item.toString();
                    setState(() {});
                  });
                },
                controller: _buscadorController,
                options: pedidos as List<String>,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 5, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 0, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: "Buscador",
                    labelStyle: stylePrincipalBold(13, Colors.grey)),
                dropdownHeight: size.height * 0.25),
          )
        : TextButton.icon(
            onPressed: () {
              setState(() {
                buscador = "";
                _buscadorController.value = null;
              });
            },
            icon: const FaIcon(
              FontAwesomeIcons.arrowRotateLeft,
              size: 20,
              color: Colors.grey,
            ),
            label: Text("Cliente: $buscador",
                style: stylePrincipalBold(14, Colors.grey)),
          );
  }
}
