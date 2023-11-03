// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, use_build_context_synchronously, prefer_typing_uninitialized_variables, unused_local_variable, unnecessary_set_literal

import 'dart:convert';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:killeradmin/global/generic_button.dart';
import 'package:killeradmin/global/loader.dart';
import 'package:killeradmin/services/http.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:uuid/uuid.dart';

import '../global/responsive.dart';
import '../global/side_menu.dart';
import '../global/style_principal.dart';
import '../global/text_field.dart';
import '../global/text_fieldl.dart';

class Eventos extends StatefulWidget {
  const Eventos({Key? key}) : super(key: key);

  @override
  _EventosState createState() => _EventosState();
}

final GlobalKey<ScaffoldState> _eventosKey = GlobalKey<ScaffoldState>();
bool isOpen = false;

String? eventSelected;

var uuid = const Uuid();

DateTime startTime = DateTime(DateTime.now().year);
DateTime eventTime = DateTime.now();

final TextEditingController _titleController = TextEditingController();
final TextEditingController _descriController = TextEditingController();
List<dynamic> auxMap = [];
Map<dynamic, dynamic> auxEvento1 = {};
Map<dynamic, dynamic> auxEvento2 = {};

class _EventosState extends State<Eventos> {
  @override
  void initState() {
    getEventos();
    super.initState();
  }

  getEventos() async {
    // urlServiceGet("eventos");
    auxMap = jsonDecode(await urlServiceGet("eventos"));
    // auxEvento1 = auxMap['events'][0];
    // auxEvento2 = auxMap['events'][1];
    print(auxMap);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _eventosKey,
      appBar: AppBar(
        leading: !Responsive.isDesktop(context)
            ? IconButton(
                icon: const FaIcon(FontAwesomeIcons.barsStaggered,
                    color: Colors.black, size: 20),
                onPressed: () {
                  _eventosKey.currentState?.openDrawer();
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
                "Eventos",
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
        padding: const EdgeInsets.all(8),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "//06",
              style: stylePrincipalBold(40, Colors.black),
            ),
            Container(
              height: size.height * 0.75,
              width: size.width,
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: [
                  SizedBox(
                      height: size.height * 0.08,
                      width: size.width,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          btnEvento("Evento 1", size),
                          btnEvento("Evento 2", size),
                        ],
                      )),
                  eventSelected! == "Evento 1"
                      ? openEvent(size, auxEvento1)
                      : openEvent(size, auxEvento2)
                ],
              ),
            ),
            bottonGeneric(size, "Subir evento", () {
              loader(context, size);
              Map<dynamic, dynamic> eventoCreate;
              if (eventSelected! == "Evento 1") {
                if (downloadUrlGet != "") {
                  downloadUrl = downloadUrlGet;
                }
                debugPrint(downloadUrl);
                auxEvento1 = {
                  "image": downloadUrl,
                  "title": _titleController.text,
                  "date": eventTime.toString(),
                  "description": _descriController.text,
                  "id": "6352d888a55ce2a29cc12d91"
                };
                eventoCreate = auxEvento1;
              } else {
                if (downloadUrlGet != "") {
                  downloadUrl = downloadUrlGet;
                }
                debugPrint(downloadUrl);
                auxEvento2 = {
                  "image": downloadUrl,
                  "title": _titleController.text,
                  "date": startTime.toString(),
                  "description": _descriController.text,
                  "id": "6352dd7ea55ce2a29cc12d95"
                };
                eventoCreate = auxEvento2;
              }
              urlServicePost('eventos', eventoCreate).whenComplete(() => {
                    setState(() {
                      Navigator.of(context).pop();
                      ElegantNotification.success(
                        toastDuration: const Duration(seconds: 5),
                        title: Text(
                          eventSelected!,
                          style: stylePrincipalBold(13, Colors.black),
                        ),
                        description: Text(
                          "Editado correctamente",
                          style: stylePrincipalBold(11, Colors.grey),
                        ),
                        width: size.width * 0.5,
                        notificationPosition: NotificationPosition.bottomRight,
                      ).show(context);
                      downloadUrlGet = "";
                      getEventos();
                    })
                  });
            }, Colors.black, context)
          ],
        ),
      ),
    );
  }

  Widget btnEvento(
    String? title,
    Size size,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          if (isOpen == false) {
            isOpen = true;
          }

          //eventSelected! = title!;
        });
      },
      child: Container(
          height: size.height * 0.06,
          width: Responsive.isDesktop(context)
              ? size.width * 0.2
              : size.width * 0.3,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.black),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(title!, style: stylePrincipalBold(14, Colors.white)),
              const FaIcon(
                FontAwesomeIcons.circlePlus,
                color: Colors.white,
                size: 20,
              )
            ],
          )),
    );
  }

  Widget openEvent(Size size, Map<dynamic, dynamic> evento) {
    _titleController.text = evento['title'];
    _descriController.text = evento['descripcion'];
    if (evento['date'] != null) {
      startTime = DateTime.parse(evento['date']);
    }
    if (evento['image'] != null) {
      downloadUrl = evento['image'];
    }

    return Container(
      height: isOpen == false ? 0 : size.height * 0.8,
      width: size.width,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: isOpen == false
            ? null
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                )
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            eventSelected!,
            style: stylePrincipalBold(15, Colors.grey),
          ),
          InkWell(
            onTap: () {
              uploadFile(size);
            },
            child: Container(
              height: size.height * 0.35,
              width: size.width * 0.8,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                      image: NetworkImage(
                          downloadUrlGet == "" ? downloadUrl : downloadUrlGet),
                      fit: BoxFit.cover)),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.camera,
                  size: 40,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.35,
            width: size.width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: size.height * 0.3,
                  width: size.width * 0.4,
                  child: Column(
                    children: [
                      customTextf(
                          _titleController, "TITULO", FontAwesomeIcons.heading),
                      customTextfLarge(_descriController, "Descripción",
                          FontAwesomeIcons.alignRight, size),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.3,
                  width: size.width * 0.4,
                  child: SfDateRangePicker(
                    confirmText: "Seleccionar",
                    selectionColor: Colors.black,
                    view: DateRangePickerView.month,
                    initialDisplayDate: startTime,
                    onSelectionChanged: onselecteddate,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void onselecteddate(
      DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs) {
    eventTime = dateRangePickerSelectionChangedArgs.value;
    setState(() {
      debugPrint(eventTime.toString());
    });
  }

  String downloadUrl = "";
  String downloadUrlGet = "";
  String errorMessage = "Imagen Subida Correctamente";

  uploadFile(Size size) async {
    loader(context, size);
    final ImagePicker picker = ImagePicker();

    var mediaData = await picker.getImage(source: ImageSource.gallery);
    var f;
    if (mediaData != null) {
      f = await mediaData.readAsBytes();
    }

    List<int> bytes = await mediaData!.readAsBytes();
    final XFile file = XFile.fromData(bytes as Uint8List);

    UploadTask uploadTask;

    // Create a Reference to the file
    Reference ref = FirebaseStorage.instance.ref().child('fotos/${uuid.v4()}');
    if (!kIsWeb) {
      TaskSnapshot uploadedFile = await ref.putData(bytes);

      if (uploadedFile.state == TaskState.success) {
        downloadUrlGet = await ref.getDownloadURL();
        Navigator.of(context).pop();
        setState(() {});
      }
      //print("No file selected");
    } else if (kIsWeb) {
      TaskSnapshot uploadedFile = await ref.putData(
        (Uint8List.fromList(bytes)),
        SettableMetadata(
          contentType: 'image/png',
        ),
      );

      if (uploadedFile.state == TaskState.success) {
        downloadUrlGet = await ref.getDownloadURL();
        Navigator.of(context).pop();
        setState(() {});
      }
    } else {}

    //return Future.value(uploadTask);
  }
}
