// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages

//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:killeradmin/global/generic_button.dart';
import 'package:killeradmin/global/style_principal.dart';
import 'package:killeradmin/global/text_field.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import "package:intl/intl.dart";

import '../../services/http.dart';

class NuevoCliente extends StatefulWidget {
  final bool? isNuevo;
  final Map<dynamic, dynamic> getDetalles;
  const NuevoCliente({Key? key, this.isNuevo, required this.getDetalles})
      : super(key: key);

  @override
  _NuevoClienteState createState() => _NuevoClienteState();
}

final TextEditingController _nombreController = TextEditingController();
final TextEditingController _apellidoController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _mailController = TextEditingController();

DateTime startTime = DateTime(1980);

Map<dynamic, dynamic> getid = {};

NumberFormat f = NumberFormat("#,##0.00", "es_US");

class _NuevoClienteState extends State<NuevoCliente> {
  @override
  void initState() {
    getDetalles().whenComplete(() {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {});
      });
    });
    super.initState();
  }

  getDetalles() async {
    debugPrint(await urlServicePost(
        "usuario/admin/orders/getOrdersById", widget.getDetalles));
    //print(getid.toString());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height,
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.all(8),
        child: widget.isNuevo == true ? formNuevo(size) : formDetalles(size));
  }

  Widget formNuevo(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Nuevo cliente",
          style: stylePrincipalBold(16, Colors.grey),
        ),
        SizedBox(
          height: size.height * 0.6,
          width: size.width,
          child: ListView(
            children: [
              SizedBox(
                width: size.width,
                child: Column(
                  children: [
                    customTextf(
                        _nombreController, "Nombre", FontAwesomeIcons.person),
                    customTextf(_apellidoController, "Apellido",
                        FontAwesomeIcons.person),
                    customTextf(
                        _mailController, "Correo", FontAwesomeIcons.envelope),
                    customTextf(_passwordController, "Contraseña",
                        FontAwesomeIcons.key),
                    SfDateRangePicker(
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs args) {
                        if (args.value is DateTimeRange) {
                          selectedDateRange = args.value as DateTimeRange;
                          print(
                              "Rango de fecha seleccionado: ${selectedDateRange!.start} - ${selectedDateRange!.end}");
                        }
                      },
                      selectionMode: DateRangePickerSelectionMode.range,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        bottonGeneric(size, "Subir cliente", () {
          subirCliente();
        }, Colors.black, context)
      ],
    );
  }

  Widget formDetalles(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Detalles de cliente",
          style: stylePrincipalBold(16, Colors.grey),
        ),
        Text(
          "${widget.getDetalles['name']}",
          style: stylePrincipalBold(13, Colors.black),
        ),
        Text(
          "Compras",
          style: stylePrincipalBold(14, Colors.grey),
        ),
        SizedBox(
          height: size.height * 0.6,
          width: size.width,
          child: ListView(
            children: [
              SizedBox(
                width: size.width,
                child: Column(
                  children: [
                    compra(size),
                    compra(size),
                    compra(size),
                    compra(size),
                    compra(size),
                    compra(size),
                    compra(size),
                    compra(size),
                    compra(size),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget compra(Size size) {
    return Container(
      height: size.height * 0.1,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage("lib/assets/comprakd.png"),
          ),
          Text(
            "titulo - ${f.format(1450)}",
            style: stylePrincipalBold(13, Colors.grey),
          ),
          Text(
            "fecha",
            style: stylePrincipalBold(11, Colors.black),
          )
        ],
      ),
    );
  }

  // void onselecteddate(
  //     DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs) {
  //print(dateRangePickerSelectionChangedArgs.value);
  // }
  DateTimeRange? selectedDateRange;
  void onselecteddate(
      DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs) {
    if (dateRangePickerSelectionChangedArgs.value is DateTimeRange) {
      selectedDateRange =
          dateRangePickerSelectionChangedArgs.value as DateTimeRange;
      DateTime startDate = selectedDateRange!.start;
      DateTime endDate = selectedDateRange!.end;
      print("Rango de fecha seleccionado: $startDate - $endDate");
    }
  }

  void subirCliente() {
    final nombre = _nombreController.text;
    final apellido = _apellidoController.text;
    final correo = _mailController.text;
    final contrasena = _passwordController.text;

    // Aquí puedes enviar los datos al servidor, por ejemplo, utilizando una llamada HTTP
    // o realizar cualquier otra lógica necesaria.
    print("Nombre: $nombre");
    print("Apellido: $apellido");
    print("Correo: $correo");
    print("Contraseña: $contrasena");
    print("Fecha: ${selectedDateRange!.start} - ${selectedDateRange!.end}");
  }
}
