// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:killeradmin/global/generic_button.dart';
import 'package:killeradmin/global/style_principal.dart';

import '../pedidos.dart';

class DetallesPedido extends StatefulWidget {
  final List<dynamic> productos;
  const DetallesPedido({Key? key, required this.productos}) : super(key: key);

  @override
  _DetallesPedidoState createState() => _DetallesPedidoState();
}

class _DetallesPedidoState extends State<DetallesPedido> {
  @override
  void initState() {
    debugPrint(widget.productos.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Detalle de pedido",
            style: stylePrincipalBold(16, Colors.grey),
          ),
          SizedBox(
            height: size.height * 0.7,
            width: size.width,
            child: ListView(
              children: [
                for (int i = 0; i <= widget.productos.length - 1; i++)
                  item(size, i),
              ],
            ),
          ),
          bottonGeneric(size, "Entregar pedido", () {}, Colors.black, context)
        ],
      ),
    );
  }

  Widget item(Size size, int index) {
    return Container(
      width: size.width,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
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
            height: size.height * 0.4,
            width: size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                    image: NetworkImage(widget.productos[index]['image'][0]),
                    fit: BoxFit.cover)),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            widget.productos[index]['name'],
            style: stylePrincipalBold(15, Colors.grey),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            widget.productos[index]['description'],
            style: stylePrincipalBold(12, Colors.black),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "descuento \$${widget.productos[index]['off']} - \$${f.format(widget.productos[index]['price'])}",
            style: stylePrincipalBold(11, Colors.grey),
          ),
        ],
      ),
    );
  }
}
