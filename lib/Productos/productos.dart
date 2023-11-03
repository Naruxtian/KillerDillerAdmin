// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages

import 'dart:convert';

import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:intl/intl.dart";
import 'package:killeradmin/Productos/components/nueva_categoria.dart';
import 'package:killeradmin/Productos/components/nuevo_producto.dart';
import '../global/generic_button.dart';
import '../global/hex.dart';
import '../global/responsive.dart';
//import '../global/screen_load.dart';
import '../global/side_menu.dart';
import '../global/style_principal.dart';
import '../services/http.dart';

class Productos extends StatefulWidget {
  const Productos({Key? key}) : super(key: key);

  @override
  _ProductosState createState() => _ProductosState();
}

final GlobalKey<ScaffoldState> _productosKey = GlobalKey<ScaffoldState>();

String buscador = "";
final _buscadorController = DropdownEditingController<String>();
List<String> productos = [];
NumberFormat f = NumberFormat("#,##0.00", "es_US");
bool isNuevo = false;

List<dynamic>? auxMap = [];
List<dynamic>? productosGet = [];

Map<dynamic, dynamic> tallas = {};
Map<dynamic, dynamic> marcas = {};
Map<dynamic, dynamic> categorias = {};
Map<dynamic, dynamic> gTags = {};
Map<dynamic, dynamic> descripciones = {};
List<dynamic> productGets = [];

bool isLoading = true;

class _ProductosState extends State<Productos> {
  @override
  void initState() {
    getData().whenComplete(() {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          isLoading = false;
        });
      });
    });
    super.initState();
  }

  getData() async {
    await getProductos();
    await getColores();
    await getMarcas();
    // getCategorias();
    // getTags();
    // getDescripciones()
  }

  getProductos() async {
    auxMap = jsonDecode(await urlServiceGet("products"));
    //print(auxMap![0]);
    productosGet = auxMap;
    setState(() {});
  }

  getColores() async {
    colores = jsonDecode(await urlServiceGet("colors"));
    // print(colores);
    setState(() {});
  }

  getMarcas() async {
    marcas = jsonDecode(await urlServiceGet("brands"));
    // print(marcas);
    setState(() {});
  }

  // getCategorias() async {
  //   categorias = jsonDecode(await urlServiceGet("categoria/obtener"));
  //   // print(categorias);
  //   setState(() {});
  // }

  // getTags() async {
  //   gTags = jsonDecode(await urlServiceGet("tags/obtener"));
  //   // print(gTags);
  //   setState(() { });
  // }

  // getDescripciones() async {
  //   descripciones = jsonDecode(await urlServiceGet("descripciones/obtener"));
  //   // print(descripciones);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //print("Productos:$auxMap");
    return Scaffold(
      backgroundColor: Colors.white,
      key: _productosKey,
      appBar: AppBar(
        leading: !Responsive.isDesktop(context)
            ? IconButton(
                icon: const FaIcon(FontAwesomeIcons.barsStaggered,
                    color: Colors.black, size: 20),
                onPressed: () {
                  _productosKey.currentState?.openDrawer();
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
                "productos",
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
                  : size.width * 0.9),
          child: isNuevo == true
              ? NuevoProducto(
                  coloresGet: colores['colores'],
                  tallasGet: tallas['tallas'],
                  marcasGet: marcas['clients'],
                  categoriasGet: categorias['categorias'],
                  tagsGet: gTags['tags'],
                  descripGet: descripciones['descripciones'],
                  isEdit: isNuevo,
                  producto: const {},
                )
              : NuevoProducto(
                  isEdit: isNuevo,
                  producto: const {},
                  coloresGet: const [],
                  tallasGet: const [],
                  marcasGet: const [],
                  categoriasGet: const [],
                  tagsGet: const [],
                  descripGet: const [],
                )),
      body: Container(
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
                        "//03",
                        style: stylePrincipalBold(40, Colors.black),
                      ),
                      buscadorW(size),
                      bottonGeneric(size, "Nuevo producto", () {
                        setState(() {
                          isNuevo = true;
                        });
                        _productosKey.currentState?.openEndDrawer();
                      }, Colors.black, context)
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "//03",
                        style: stylePrincipalBold(40, Colors.black),
                      ),
                      buscadorW(size),
                      const SizedBox(
                        height: 8,
                      ),
                      bottonGeneric(size, "Nuevo producto", () {
                        setState(() {
                          isNuevo = true;
                        });
                        _productosKey.currentState?.openEndDrawer();
                      }, Colors.black, context)
                    ],
                  ),
            Container(
              height: Responsive.isDesktop(context)
                  ? size.height * 0.8
                  : size.height * .6,
              width: size.width,
              padding: const EdgeInsets.all(8),
              child: Responsive.isDesktop(context)
                  ? GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, //columnas
                        mainAxisSpacing: 10.0, //espacio entre cards
                        crossAxisSpacing: 10,
                        childAspectRatio: 1, // largo de la card
                      ),
                      itemCount: auxMap!.length,
                      itemBuilder: (BuildContext context, var index) {
                        return _buildProducto(size, index);
                      },
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: auxMap!.length,
                      itemBuilder: (BuildContext context, var index) {
                        return _buildProducto(size, index);
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }

  openModal(Size size) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: size.height * 0.5,
            color: Colors.transparent,
            child: Padding(
                padding: Responsive.isDesktop(context)
                    ? const EdgeInsets.fromLTRB(350, 0, 150, 0)
                    : const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: const NuevaCategoria()),
          );
        });
  }

  Widget _buildProducto(Size size, int ind) {
    var productoGet = auxMap![ind];
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
                "Detalles del producto",
                style: stylePrincipalBold(11, Colors.grey),
              ),
              trailingIcon: const Icon(FontAwesomeIcons.penToSquare,
                  color: Colors.orange, size: 20),
              onPressed: () {
                setState(() {
                  isNuevo = false;
                  // productGets = productoGet;
                });
                _productosKey.currentState?.openEndDrawer();
              }),
          FocusedMenuItem(
              title: Text(
                "Eliminar producto",
                style: stylePrincipalBold(11, Colors.grey),
              ),
              trailingIcon: const Icon(FontAwesomeIcons.trash,
                  color: Colors.red, size: 20),
              onPressed: () {
                urlServiceDelete('producto/eliminar', productoGet['_id']);
              }),
        ],
        onPressed: () {},
        child: Container(
          height: size.height * 0.45,
          width: size.width,
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: size.height * 0.3,
                width: size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(productoGet['images'][0]),
                        fit: BoxFit.cover)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  for (var i = 0; i < productoGet['colors'].length; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: FaIcon(
                        FontAwesomeIcons.circleDot, 
                        color: HexColor(productoGet['colors'][i]['hex']), 
                        size: 20
                      ),
                    )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    productoGet['title'],
                    style: stylePrincipalBold(13, Colors.black),
                  ),
                  Text(
                    productoGet['description'],
                    style: stylePrincipalBold(11, Colors.grey),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        productoGet['isSold'] == true
                            ? "Vendido"
                            : "Sin vender",
                        style: stylePrincipalBold(
                            15,
                            productoGet['isSold'] == true
                                ? Colors.green
                                : Colors.red),
                      ),
                      Text(
                        "\$${f.format(productoGet['price'])}",
                        style: stylePrincipalBold(15, Colors.grey),
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
                options: productos,
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
            label: Text("Producto: $buscador",
                style: stylePrincipalBold(14, Colors.grey)),
          );
  }
}
