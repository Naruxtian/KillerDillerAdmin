// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:killeradmin/global/style_principal.dart';
import 'package:killeradmin/global/text_field.dart';

import '../../global/responsive.dart';

class NuevaCategoria extends StatefulWidget {
  const NuevaCategoria({Key? key}) : super(key: key);

  @override
  _NuevaCategoriaState createState() => _NuevaCategoriaState();
}

final TextEditingController _nombreController = TextEditingController();

List<String> tagoptions = [
  'News',
  'Entertainment',
  'Politics',
  'Automotive',
  'Sports',
  'Education',
  'Fashion',
  'Travel',
  'Food',
  'Tech',
  'Science',
];

class _NuevaCategoriaState extends State<NuevaCategoria> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
        length: 4,
        child: Container(
          height: size.height * 0.5,
          width: size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.white),
          child: Column(
            children: [
              TabBar(
                indicatorColor: Colors.grey,
                tabs: [
                  Tab(
                      icon: const FaIcon(FontAwesomeIcons.tags,
                          size: 20, color: Colors.grey),
                      child: Text(
                        "Tags",
                        style: stylePrincipalBold(13, Colors.black),
                      )),
                  Tab(
                      icon: const FaIcon(
                        FontAwesomeIcons.certificate,
                        size: 20,
                        color: Colors.grey,
                      ),
                      child: Text(
                        "Categorias",
                        style: stylePrincipalBold(13, Colors.black),
                      )),
                  Tab(
                      icon: const FaIcon(
                        FontAwesomeIcons.brandsFontAwesome,
                        size: 20,
                        color: Colors.grey,
                      ),
                      child: Text(
                        "Marcas",
                        style: stylePrincipalBold(13, Colors.black),
                      )),
                  Tab(
                      icon: const FaIcon(
                        FontAwesomeIcons.paragraph,
                        size: 20,
                        color: Colors.grey,
                      ),
                      child: Text(
                        "Descripciones",
                        style: stylePrincipalBold(13, Colors.black),
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.width * 0.5,
                    height: size.height * 0.08,
                    child: customTextf(
                        _nombreController, "Nombre", FontAwesomeIcons.fileText),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const FaIcon(
                        FontAwesomeIcons.download,
                        size: 20,
                        color: Colors.grey,
                      ))
                ],
              ),
              SizedBox(
                  height: size.height * 0.3,
                  width: Responsive.isDesktop(context)
                      ? size.width * 0.65
                      : size.width,
                  child: TabBarView(
                    children: [tags(size)],
                  ))
            ],
          ),
        ));
  }

  Widget tags(Size size) {
    return SizedBox(
      height: size.height * 0.3,
      width: size.width,
      child: Responsive.isDesktop(context)
          ? GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, //columnas
                mainAxisSpacing: 10.0, //espacio entre cards
                crossAxisSpacing: 10,
                childAspectRatio: 3, // largo de la card
              ),
              itemCount: tagoptions.length,
              itemBuilder: (BuildContext context, var index) {
                return _buildText(size, index);
              },
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: tagoptions.length,
              itemBuilder: (BuildContext context, var index) {
                return _buildText(size, index);
              },
            ),
    );
  }

  _buildText(Size size, index) {
    return TextButton.icon(
        onPressed: () {},
        icon: const FaIcon(
          FontAwesomeIcons.xmark,
          size: 20,
          color: Colors.grey,
        ),
        label: Text(
          tagoptions[index],
          style: stylePrincipalBold(11, Colors.grey),
        ));
  }
}
