// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use, prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:killeradmin/global/text_fieldl.dart';
import 'package:killeradmin/global/text_fieldn.dart';

import '../../Eventos/eventos.dart';
import '../../global/generic_button.dart';
import '../../global/hex.dart';
import '../../global/responsive.dart';
import '../../global/style_principal.dart';
import '../../global/text_field.dart';
import '../../services/http.dart';
import '../productos.dart';

class NuevoProducto extends StatefulWidget { 
  final List<dynamic>? coloresGet;
  final List<dynamic>? tallasGet;
  final List<dynamic>? marcasGet;
  final List<dynamic>? categoriasGet;
  final List<dynamic>? tagsGet;
  final List<dynamic>? descripGet;
  final bool isEdit;
  final Map<dynamic, dynamic> producto;
  const NuevoProducto(
      {Key? key,
      this.coloresGet,
      this.tallasGet,
      this.marcasGet,
      this.categoriasGet,
      this.tagsGet,
      this.descripGet,
      required this.isEdit,
      required this.producto})
      : super(key: key);

  @override
  _NuevoProductoState createState() => _NuevoProductoState();
}

final TextEditingController _nombreController = TextEditingController();
final TextEditingController _descController = TextEditingController();
final TextEditingController _precioController = TextEditingController();
final TextEditingController _stockController = TextEditingController();
final TextEditingController _descuentoController = TextEditingController();
final TextEditingController _colorController = TextEditingController();

final TextEditingController _tallaController = TextEditingController();
final TextEditingController _descTallaController = TextEditingController();

double estadoInt = 0, estadoExt = 0;

Map<dynamic, dynamic> fotos = {};

//buscar colores
Map<dynamic, dynamic> colores = {};
Map<dynamic, dynamic> coloreSel = {};
String colorSel = "";
List<String> coloresBusc = [];

//buscar tallas
String tallaSel = "";
List<String> tallasBusc = [];

//buscar marcas
String marcaSel = "";
List<String> marcasBusc = [];
List<String> marcasGet = [];

//buscar categoria
String categoriaSel = "";
List<String> categoriasBusc = [];
List<String> categoriasGet = [];

//buscar tag
String tagSel = "";
List<String> tagsBusc = [];

//buscar descrip
String descripSel = "";
List<String> descripBusc = [];

String buscador = "";
final _buscadorController = DropdownEditingController<String>();

Color pickerColor = const Color(0xff443a49);
Color currentColor = const Color(0xff443a49);

String hexColor = "Color";

//tags
int tag = 1;
List<String> tagoptions = [];

List<String> tags = [];
List<String> tagsGet = [];
List<String> auxtag = ['Kd'];

//descripciones
int descr = 1;
List<String> descptions = [];

List<dynamic>? auxGetdescripciones = [];
List<String> auxdesc = ['Kd'];
List<dynamic>? auxGetColores = [];
List<dynamic>? auxGetTallas = [];
List<dynamic>? auxGetMarcas = [];
List<dynamic>? auxGetCategorias = [];
List<dynamic>? auxGetTags = [];

bool isSold = false;

Color? colorS;

class _NuevoProductoState extends State<NuevoProducto> {
  @override
  void initState() {
    getData();
    if (widget.isEdit == true) {
      //initSt();
    }

    print(widget.producto);
    super.initState();
  }

  initSt() {
    coloresBusc.clear();
    if (auxGetColores!.isEmpty) {
      for (var i in widget.coloresGet!) {
        coloresBusc.add(i['name']);
      }
    } else {
      for (var i in auxGetColores!) {
        coloresBusc.add(i['name']);
      }
    }

    tallasBusc.clear();
    if (auxGetTallas!.isEmpty) {
      for (var i in widget.tallasGet!) {
        tallasBusc.add(i['size']);
      }
    } else {
      for (var i in auxGetTallas!) {
        print("Entrando for Tallas");
        tallasBusc.add(i['size']);
      }
    }

    marcasBusc.clear();
    if (auxGetMarcas!.isEmpty) {
      for (var i in widget.marcasGet!) {
        marcasBusc.add(i['name']);
      }
    } else {
      for (var i in auxGetMarcas!) {
        print("Entrando for Marcas");
        marcasBusc.add(i['name']);
      }
    }

    categoriasBusc.clear();
    if (auxGetCategorias!.isEmpty) {
      for (var i in widget.categoriasGet!) {
        categoriasBusc.add(i['category']);
      }
    } else {
      for (var i in auxGetCategorias!) {
        print("Entrando for Categorias");
        categoriasBusc.add(i['category']);
      }
    }

    // if (auxGetTags!.isEmpty) {
    //   for (var i in widget.tagsGet!) {
    //     tagsBusc.add(i['name']);
    //   }
    // } else {
    //   for (var i in auxGetTags!) {
    //     tagsBusc.add(i['name']);
    //   }
    // }

    if (auxGetdescripciones!.isEmpty) {
      for (var i in widget.descripGet!) {
        descripBusc.add(i['description']);
      }
    } else {
      for (var i in auxGetdescripciones!) {
        descripBusc.add(i['description']);
      }
    }
  }

  getData() async{
    print('si');
    await getColores();
    await getMarcas();
    await getCategorias();
    await getTallas();
    await getDescripciones();
    print("colores: $colores");
  }

  getColores() async {
    colores = jsonDecode(await urlServiceGet("colors"));
    auxGetColores = colores['colors'];
    // print("colores:");
    // print(colores);
    // print("auxGetColores:");
    // print(auxGetColores);
    initSt();
  }

  getTallas() async {
    tallas = jsonDecode(await urlServiceGet("sizes"));
    auxGetTallas = tallas['sizes'];
    // print("tallas:");
    // print(tallas);
    // print("auxGetTallas:");
    // print(auxGetTallas);
    initSt();
  }

  getMarcas() async {
    marcas = jsonDecode(await urlServiceGet("brands"));
    auxGetMarcas = marcas['brands'];
    // print("marcas:");
    // print(marcas);
    // print("auxGetMarcas:");
    // print(auxGetMarcas);
    initSt();
  }

  getCategorias() async {
    categorias = jsonDecode(await urlServiceGet("category"));
    auxGetCategorias = categorias['category'];
    // print("categorias:");
    // print(categorias);
    // print("auxGetCategorias:");
    // print(auxGetCategorias);
    initSt();
  }

  // getTags() async {
  //   urlServiceGet("tags/obtener");
  //   gTags = jsonDecode(await urlServiceGet("tags/obtener"));
  //   auxGetTags = gTags['tags'];
  //   initSt();
  // }

  getDescripciones() async {
    descripciones = jsonDecode(await urlServiceGet("information"));
    auxGetdescripciones = descripciones['information'];
    // print("descripciones:");
    // print(descripciones);
    // print("auxGetdescripciones:");
    // print(auxGetdescripciones);
    //print(auxGetdescripciones);
    initSt();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height,
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.all(8),
        child: formNuevo(size));
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Widget formNuevo(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "nuevo producto",
          style: stylePrincipalBold(16, Colors.grey),
        ),
        SizedBox(
          height: size.height * 0.7,
          width: size.width,
          child: ListView(
            children: [
              SizedBox(
                width: size.width,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();

                        var mediaData =
                            await picker.getImage(source: ImageSource.gallery);

                        List<int> bytes = await mediaData!.readAsBytes();
                        fotos.putIfAbsent(bytes, () => null);

                        setState(() {});
                      },
                      child: Container(
                        height: size.height * 0.1,
                        width: size.width * 0.1,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.camera,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Imagenes Seleccionadas",
                      style: stylePrincipalBold(13, Colors.grey),
                    ),
                    SizedBox(
                        height: size.height * 0.35,
                        width: size.width,
                        child: fotos.isEmpty
                            ? Center(
                                child: Text(
                                  "AÚN NO HAZ SELECCIONADO NINGUNA FOTO.",
                                  style: stylePrincipalBold(14, Colors.black),
                                ),
                              )
                            : ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  for (var i in fotos.keys)
                                    Container(
                                      height: size.height * 0.25,
                                      width: size.width * 0.25,
                                      margin: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          image: DecorationImage(
                                              image: MemoryImage(i),
                                              fit: BoxFit.cover)),
                                      child: const Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.checkDouble,
                                          size: 30,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                ],
                              )),
                    customTextf(
                        _nombreController, "Nombre", FontAwesomeIcons.person),
                    customTextfLarge(_descController, "DescripciÓn",
                        FontAwesomeIcons.paragraph, size),
                    customTextfN(_precioController, "Precio",
                        FontAwesomeIcons.moneyBill),
                    customTextfN(
                        _stockController, "Stock", FontAwesomeIcons.box),
                    customTextfN(_descuentoController, "Descuento",
                        FontAwesomeIcons.percent),
                    const SizedBox(
                      height: 30,
                    ),
                    rating(size),
                    buscadores(size),
                    Content(
                      title: 'Tags',
                      child: ChipsChoice<int>.single(
                        value: tag,
                        onChanged: (val) => setState(() => tag = val),
                        choiceItems: C2Choice.listFrom<int, String>(
                          source: tags.isEmpty ? auxtag : tags,
                          value: (i, v) => i,
                          label: (i, v) => v,
                          tooltip: (i, v) => v,
                          delete: (i, v) => () {
                            setState(() => tags.removeAt(i));
                          },
                        ),
                        choiceStyle: C2ChipStyle.toned(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        leading: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buscadorTags(size),
                            SizedBox(
                              height: size.height * 0.07,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  TextButton.icon(
                                      label: Text(
                                        "Nuevo",
                                        style: stylePrincipalBold(
                                            13, Colors.black),
                                      ),
                                      onPressed: () {
                                        showTagsCreate(size);
                                      },
                                      icon: const FaIcon(
                                        FontAwesomeIcons.plusCircle,
                                        color: Colors.black,
                                        size: 20,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        wrapped: true,
                      ),
                    ),
                    Content(
                      title: 'Descripciones',
                      child: ChipsChoice<int>.single(
                        value: descr,
                        onChanged: (val) => setState(() => descr = val),
                        choiceItems: C2Choice.listFrom<int, String>(
                          source: descptions.isEmpty ? auxdesc : descptions,
                          value: (i, v) => i,
                          label: (i, v) => v,
                          tooltip: (i, v) => v,
                          delete: (i, v) => () {
                            setState(() => descptions.removeAt(i));
                          },
                        ),
                        choiceStyle: C2ChipStyle.toned(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        leading: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buscadorDescr(size),
                            SizedBox(
                              height: size.height * 0.07,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  TextButton.icon(
                                      label: Text(
                                        "nueva",
                                        style: stylePrincipalBold(
                                            13, Colors.black),
                                      ),
                                      onPressed: () {
                                        showDescriptionCreate(size);
                                      },
                                      icon: const FaIcon(
                                        FontAwesomeIcons.plusCircle,
                                        color: Colors.black,
                                        size: 20,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        wrapped: true,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AnimatedToggleSwitch<bool>.dual(
                      current: isSold,
                      first: false,
                      second: true,
                      dif: 50.0,
                      borderColor: Colors.transparent,
                      borderWidth: 5.0,
                      height: 55,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1.5),
                        ),
                      ],
                      onChanged: (b) => setState(() => isSold = b),
                      colorBuilder: (b) => b ? Colors.red : Colors.green,
                      iconBuilder: (value) => value
                          ? const FaIcon(
                              FontAwesomeIcons.close,
                              color: Colors.white,
                              size: 20,
                            )
                          : const FaIcon(
                              FontAwesomeIcons.moneyBill1Wave,
                              color: Colors.white,
                              size: 20,
                            ),
                      textBuilder: (value) => value
                          ? Center(
                              child: Text(
                              'Sin vender',
                              style: stylePrincipalBold(12, Colors.grey),
                            ))
                          : Center(
                              child: Text(
                              'Vendido',
                              style: stylePrincipalBold(12, Colors.grey),
                            )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        bottonGeneric(size, "Subir producto", () {
          uploadProduct(size);
        }, Colors.black, context)
      ],
    );
  }

  Widget buscadorTags(Size size) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      height: size.height * 0.07,
      width:
          Responsive.isDesktop(context) ? size.width * 0.2 : size.width * 0.6,
      child: TextDropdownFormField(
          onChanged: (dynamic item) {
            setState(() {
              tagSel = item.toString();
              if (auxGetTags!.isEmpty) {
                for (var i in widget.tagsGet!) {
                  if (i['name'] == tagSel) {
                    tagSel = i['name'];
                    tags.add(item.toString());
                    tagsGet.add(i.toString());
                  }
                }
              } else {
                for (var i in auxGetTags!) {
                  if (i['name'] == tagSel) {
                    tagSel = i['name'];
                    tagsGet.add(i.toString());
                  }
                }
              }
            });
          },
          controller: _buscadorController,
          options: tagsBusc,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 5, color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 0, color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              labelText: "Tags",
              labelStyle: stylePrincipalBold(13, Colors.grey)),
          dropdownHeight: size.height * 0.25),
    );
  }

  Widget buscadorDescr(Size size) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      height: size.height * 0.07,
      width:
          Responsive.isDesktop(context) ? size.width * 0.2 : size.width * 0.6,
      child: TextDropdownFormField(
          onChanged: (dynamic item) {
            setState(() {
              descripSel = item.toString();
              if (auxGetdescripciones!.isEmpty) {
                for (var i in widget.descripGet!) {
                  if (i['name'] == descripSel) {
                    descripSel = i['name'];
                    descptions.add(item.toString());
                  }
                }
              } else {
                for (var i in auxGetdescripciones!) {
                  if (i['name'] == descripSel) {
                    descripSel = i['name'];
                    descptions.add(item.toString());
                  }
                }
              }
            });
          },
          controller: _buscadorController,
          options: descripBusc,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 5, color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 0, color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              labelText: "Descripciones",
              labelStyle: stylePrincipalBold(13, Colors.grey)),
          dropdownHeight: size.height * 0.25),
    );
  }

  Widget buscadorCategoria(Size size) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      height: size.height * 0.07,
      width:
          Responsive.isDesktop(context) ? size.width * 0.2 : size.width * 0.6,
      child: TextDropdownFormField(
          onChanged: (dynamic item) {
            setState(() {
              categoriaSel = item.toString();
              if (auxGetCategorias!.isEmpty) {
                for (var i in widget.categoriasGet!) {
                  if (i['name'] == categoriaSel) {
                    categoriaSel = i['name'];
                    categoriasGet.add(i.toString());
                  }
                }
              } else {
                for (var i in auxGetCategorias!) {
                  if (i['name'] == categoriaSel) {
                    categoriaSel = i['name'];
                    categoriasGet.add(i.toString());
                  }
                }
              }
            });
          },
          controller: _buscadorController,
          options: categoriasBusc,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 5, color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 0, color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              labelText: "Categoria",
              labelStyle: stylePrincipalBold(13, Colors.grey)),
          dropdownHeight: size.height * 0.25),
    );
  }

  Widget buscadortallas(Size size) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      height: size.height * 0.07,
      width:
          Responsive.isDesktop(context) ? size.width * 0.2 : size.width * 0.6,
      child: TextDropdownFormField(
          onChanged: (dynamic item) {
            setState(() {
              if (auxGetTallas!.isEmpty) {
                for (var i in widget.tallasGet!) {
                  if (i['name'] == item.toString()) {
                    tallaSel = i['descripcion'];
                  }
                }
              } else {
                for (var i in auxGetTallas!) {
                  if (i['name'] == item.toString()) {
                    tallaSel = i['descripcion'];
                  }
                }
              }
            });
          },
          controller: _buscadorController,
          options: tallasBusc,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 5, color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 0, color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              labelText: "Tallas",
              labelStyle: stylePrincipalBold(13, Colors.grey)),
          dropdownHeight: size.height * 0.25),
    );
  }

  Widget buscadorColores(Size size) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      height: size.height * 0.07,
      width:
          Responsive.isDesktop(context) ? size.width * 0.2 : size.width * 0.6,
      child: TextDropdownFormField(
          onChanged: (dynamic item) {
            setState(() {
              colorSel = item.toString();
              if (auxGetColores!.isEmpty) {
                for (var i in widget.coloresGet!) {
                  if (i['name'] == colorSel) {
                    colorS = HexColor(i['hex']);
                    coloreSel = i;
                  }
                }
              } else {
                for (var i in auxGetColores!) {
                  if (i['name'] == colorSel) {
                    colorS = HexColor(i['hex']);
                    coloreSel = i;
                  }
                }
              }
            });
          },
          controller: _buscadorController,
          options: coloresBusc,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 5, color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 0, color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              labelText: "Colores",
              labelStyle: stylePrincipalBold(13, Colors.grey)),
          dropdownHeight: size.height * 0.25),
    );
  }

  Widget buscadorMarca(Size size) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      height: size.height * 0.07,
      width:
          Responsive.isDesktop(context) ? size.width * 0.2 : size.width * 0.6,
      child: TextDropdownFormField(
          onChanged: (dynamic item) {
            setState(() {
              marcaSel = item.toString();
              if (auxGetMarcas!.isEmpty) {
                for (var i in widget.marcasGet!) {
                  if (i['name'] == marcaSel) {
                    marcaSel = i['name'];
                    marcasGet.add(i.toString());
                  }
                }
              } else {
                for (var i in auxGetMarcas!) {
                  if (i['name'] == marcaSel) {
                    marcaSel = i['name'];
                    marcasGet.add(i.toString());
                  }
                }
              }
            });
          },
          controller: _buscadorController,
          options: marcasBusc,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 5, color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 0, color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              labelText: "Marca",
              labelStyle: stylePrincipalBold(13, Colors.grey)),
          dropdownHeight: size.height * 0.25),
    );
  }

  void showColorPicker(Size size) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Selecciona un color',
              style: stylePrincipalBold(15, Colors.black),
            ),
            content: SingleChildScrollView(
                child: MaterialPicker(
              pickerColor: pickerColor,
              onColorChanged: changeColor,
            )),
            actions: <Widget>[
              customTextf(
                _colorController,
                "Nombre",
                FontAwesomeIcons.brush,
              ),
              bottonGeneric(size, "Listo", () {
                setState(() => currentColor = pickerColor);
                setState(() {
                  hexColor = ColorUtils.intToHex(currentColor.value);
                  Map<dynamic, dynamic> crearColor = {};
                  crearColor = {"hex": hexColor, "name": _colorController.text};
                  print(crearColor.toString());
                  urlServicePost('colores/crear', crearColor)
                      .whenComplete(() => setState(() {
                            getColores();
                            _colorController.text = "";
                            Navigator.of(context).pop();
                          }));
                });
              }, Colors.black, context)
            ],
          );
        });
  }

  void showDescriptionCreate(Size size) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Crear descripciÓn',
              style: stylePrincipalBold(15, Colors.black),
            ),
            actions: <Widget>[
              customTextf(
                _tallaController,
                "Nombre",
                FontAwesomeIcons.solidWindowMaximize,
              ),
              customTextfLarge(_descTallaController, "DescripciÓn",
                  FontAwesomeIcons.solidWindowMaximize, size),
              bottonGeneric(size, "Listo", () {
                setState(() {
                  Map<dynamic, dynamic> crearDesc = {};
                  crearDesc = {
                    "name": _tallaController.text,
                    "description": _descTallaController.text
                  };
                  print(crearDesc.toString());
                  urlServicePost('descripciones/crear', crearDesc)
                      .whenComplete(() => setState(() {
                            getDescripciones();
                            _tallaController.text = "";
                            _descTallaController.text = "";
                            Navigator.of(context).pop();
                          }));
                });
              }, Colors.black, context)
            ],
          );
        });
  }

  void showTallaCreate(Size size) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Crear talla',
              style: stylePrincipalBold(15, Colors.black),
            ),
            actions: <Widget>[
              customTextf(
                _tallaController,
                "Talla",
                FontAwesomeIcons.solidWindowMaximize,
              ),
              customTextfLarge(_descTallaController, "DescripciÓn",
                  FontAwesomeIcons.solidWindowMaximize, size),
              bottonGeneric(size, "Listo", () {
                setState(() {
                  Map<dynamic, dynamic> crearTalla = {};
                  crearTalla = {
                    "name": _tallaController.text,
                    "descripcion": _descTallaController.text
                  };
                  print(crearTalla.toString());
                  urlServicePost('talla/crear', crearTalla)
                      .whenComplete(() => setState(() {
                            getTallas();
                            _tallaController.text = "";
                            _descTallaController.text = "";
                            Navigator.of(context).pop();
                          }));
                });
              }, Colors.black, context)
            ],
          );
        });
  }

  void showTagsCreate(Size size) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Crear tag',
              style: stylePrincipalBold(15, Colors.black),
            ),
            actions: <Widget>[
              customTextf(
                _tallaController,
                "tag",
                FontAwesomeIcons.solidWindowMaximize,
              ),
              bottonGeneric(size, "Listo", () {
                setState(() {
                  Map<dynamic, dynamic> crearMarca = {};
                  crearMarca = {
                    "name": _tallaController.text,
                  };
                  print(crearMarca.toString());
                  urlServicePost('tags/crear', crearMarca)
                      .whenComplete(() => setState(() {
                            // getTags();
                            _tallaController.text = "";
                            Navigator.of(context).pop();
                          }));
                });
              }, Colors.black, context)
            ],
          );
        });
  }

  void showMarcaCreate(Size size) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Crear marca',
              style: stylePrincipalBold(15, Colors.black),
            ),
            actions: <Widget>[
              customTextf(
                _tallaController,
                "marca",
                FontAwesomeIcons.solidWindowMaximize,
              ),
              bottonGeneric(size, "Listo", () {
                setState(() {
                  Map<dynamic, dynamic> crearMarca = {};
                  crearMarca = {
                    "name": _tallaController.text,
                  };
                  print(crearMarca.toString());
                  urlServicePost('marca/crear', crearMarca)
                      .whenComplete(() => setState(() {
                            getMarcas();
                            _tallaController.text = "";
                            Navigator.of(context).pop();
                          }));
                });
              }, Colors.black, context)
            ],
          );
        });
  }

  void showCategoriaCreate(Size size) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Crear categoria',
              style: stylePrincipalBold(15, Colors.black),
            ),
            actions: <Widget>[
              customTextf(
                _tallaController,
                "categoria",
                FontAwesomeIcons.solidWindowMaximize,
              ),
              bottonGeneric(size, "Listo", () {
                setState(() {
                  Map<dynamic, dynamic> crearCategoria = {};
                  crearCategoria = {
                    "name": _tallaController.text,
                  };
                  print(crearCategoria.toString());
                  urlServicePost('categoria/crear', crearCategoria)
                      .whenComplete(() => setState(() {
                            getCategorias();
                            _tallaController.text = "";
                            Navigator.of(context).pop();
                          }));
                });
              }, Colors.black, context)
            ],
          );
        });
  }

  late String downloadUrl;
  List<String> donwImages = [];

  uploadProduct(Size size) async {
    //loader(context, size);
    Map<dynamic, dynamic> product = {};
    for (var i in fotos.keys) {
      downloadUrl = "";

      // Create a Reference to the file
      Reference ref =
          FirebaseStorage.instance.ref().child('fotos/${uuid.v4()}');
      if (!kIsWeb) {
        TaskSnapshot uploadedFile = await ref.putData(i);

        if (uploadedFile.state == TaskState.success) {
          downloadUrl = await ref.getDownloadURL();

          setState(() {});
        }
        print("No file selected");
      } else if (kIsWeb) {
        TaskSnapshot uploadedFile = await ref.putData(
          (Uint8List.fromList(i)),
          SettableMetadata(
            contentType: 'image/png',
          ),
        );

        if (uploadedFile.state == TaskState.success) {
          downloadUrl = await ref.getDownloadURL();
          if (!donwImages.contains(downloadUrl)) {
            donwImages.add(downloadUrl);
          }
          setState(() {});
        }
      } else {}
    }

    product = {
      "images": donwImages.toString(),
      "title": _nombreController.text,
      "price": double.parse(_precioController.text).toString(),
      "description": _descController.text,
      "tags": tagsGet.toString(),
      "discount": double.parse(_descuentoController.text).toString(),
      "externalCondition": estadoExt.toString(),
      "internalCondition": estadoInt.toString(),
      "isSold": isSold.toString(),
      "stock": double.parse(_stockController.text).toString(),
      "brand": marcasGet.toString(),
      "category": categoriasGet.toString(),
      "color": coloreSel.toString()
    };

    print(product);

    urlServicePost('producto/crear', product)
        .whenComplete(() => Navigator.of(context).pop());
  }

  //input widgets
  //ratings
  Widget rating(Size size) {
    return Card(
      elevation: 2,
      child: Container(
        width: size.width,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              "Estado interior",
              style: stylePrincipalBold(13, Colors.grey),
            ),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const FaIcon(
                FontAwesomeIcons.star,
                color: Colors.amber,
                size: 14,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  estadoExt = rating;
                });
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Estado exterior",
              style: stylePrincipalBold(13, Colors.grey),
            ),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const FaIcon(
                FontAwesomeIcons.star,
                color: Colors.amber,
                size: 14,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  estadoInt = rating;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // tallas - colores - marcas - categoria
  Widget buscadores(Size size) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buscadorColores(size),
                SizedBox(
                  height: size.height * 0.07,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      TextButton.icon(
                          label: Text(
                            "Nuevo",
                            style: stylePrincipalBold(13, Colors.black),
                          ),
                          onPressed: () {
                            showColorPicker(size);
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.plusCircle,
                            color: Colors.black,
                            size: 20,
                          )),
                    ],
                  ),
                ),
              ],
            ),
            colorSel != ""
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        colorSel,
                        style: stylePrincipalBold(13, colorS!),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      FaIcon(FontAwesomeIcons.circleDot,
                          color: colorS, size: 20)
                    ],
                  )
                : const SizedBox(),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buscadortallas(size),
                SizedBox(
                  height: size.height * 0.07,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      TextButton.icon(
                          label: Text(
                            "nueva",
                            style: stylePrincipalBold(13, Colors.black),
                          ),
                          onPressed: () {
                            showTallaCreate(size);
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.plusCircle,
                            color: Colors.black,
                            size: 20,
                          )),
                    ],
                  ),
                ),
              ],
            ),
            tallaSel != ""
                ? Text(
                    tallaSel,
                    style: stylePrincipalBold(13, Colors.black),
                  )
                : const SizedBox(),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buscadorCategoria(size),
                SizedBox(
                  height: size.height * 0.07,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      TextButton.icon(
                          label: Text(
                            "nueva",
                            style: stylePrincipalBold(13, Colors.black),
                          ),
                          onPressed: () {
                            showCategoriaCreate(size);
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.plusCircle,
                            color: Colors.black,
                            size: 20,
                          )),
                    ],
                  ),
                ),
              ],
            ),
            categoriaSel != ""
                ? Text(
                    categoriaSel,
                    style: stylePrincipalBold(13, Colors.black),
                  )
                : const SizedBox(),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buscadorMarca(size),
                SizedBox(
                  height: size.height * 0.07,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      TextButton.icon(
                          label: Text(
                            "nueva",
                            style: stylePrincipalBold(13, Colors.black),
                          ),
                          onPressed: () {
                            showMarcaCreate(size);
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.plusCircle,
                            color: Colors.black,
                            size: 20,
                          )),
                    ],
                  ),
                ),
              ],
            ),
            marcaSel != ""
                ? Text(
                    marcaSel,
                    style: stylePrincipalBold(13, Colors.black),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class Content extends StatefulWidget {
  final String title;
  final Widget child;

  const Content({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  ContentState createState() => ContentState();
}

class ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(5),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            // color: Colors.blueGrey[50],
            child: Text(
              widget.title,
              style: const TextStyle(
                // color: Colors.blueGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Flexible(fit: FlexFit.loose, child: widget.child),
        ],
      ),
    );
  }
}
