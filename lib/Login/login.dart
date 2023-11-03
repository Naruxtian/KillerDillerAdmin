// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:killeradmin/global/loader.dart';
import 'package:killeradmin/global/responsive.dart';
import 'package:killeradmin/global/style_principal.dart';

import '../global/snack_bar.dart';
import '../main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Responsive.isDesktop(context)
            ? loginEscritorio(size)
            : loginMobil(size));
  }

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();

  bool isObsc = true;
  bool isError = false;
  String error = "error!";

  Widget loginEscritorio(Size size) {
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Row(
        children: [
          Container(
            width: size.width * 0.4,
            height: size.height,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    bottomRight: Radius.circular(40)),
                image: DecorationImage(
                    image: AssetImage(
                      "lib/assets/fondolog.webp",
                    ),
                    fit: BoxFit.fitHeight)),
            child: Stack(
              children: [
                Positioned(
                  left: size.width * 0.1,
                  top: size.height * 0.3,
                  child: Column(
                    children: [
                      Text(
                        "//01",
                        style: stylePrincipalBold(40, Colors.black),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    child: VerticalDivider(
                  color: Colors.black,
                  width: size.width * 0.1,
                  thickness: 5,
                  indent: size.height * 0.4,
                  endIndent: 20,
                ))
              ],
            ),
          ),
          boxLogin(size)
        ],
      ),
    );
  }

  Widget loginMobil(Size size) {
    return Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "lib/assets/fondolog.webp",
                ),
                fit: BoxFit.fitHeight)),
        child: boxLogin(size));
  }

  Widget boxLogin(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Bienvenido admin",
          style: stylePrincipalBold(15, Colors.grey),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.only(left: size.width * 0.05),
          height: Responsive.isDesktop(context)
              ? size.height * 0.5
              : size.height * 0.7,
          width: Responsive.isDesktop(context)
              ? size.width * 0.5
              : size.width * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
              Column(
                children: [
                  const CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage("lib/assets/logoKd.jpg"),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Inicio de SesiÓn",
                    style: stylePrincipalBold(18, Colors.black),
                  )
                ],
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: TextField(
                      controller: _usuarioController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person,
                            size: 20, color: Colors.black),
                        hintStyle: stylePrincipalBold(14, Colors.grey),
                        hintText: "Correo",
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 2.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 2.0),
                        ),
                      ),
                      style: stylePrincipalBold(13, Colors.grey),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: isObsc,
                      decoration: InputDecoration(
                        hintStyle: stylePrincipalBold(14, Colors.grey),
                        hintText: "ContraseÑa",
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isObsc = !isObsc;
                              });
                            },
                            icon: Icon(
                                isObsc == true
                                    ? Icons.remove_red_eye
                                    : Icons.close,
                                color: Colors.black,
                                size: 20)),
                        prefixIcon: const Icon(Icons.lock,
                            color: Colors.black, size: 18),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 2.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 2.0),
                        ),
                      ),
                      style: stylePrincipalBold(13, Colors.grey),
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                  onPressed: () {
                    if (_usuarioController.text.isEmpty ||
                        _passwordController.text.isEmpty) {
                      snackbarW(size, context, "No deje campos vacios",
                          Icons.error, Colors.red);
                    } else {
                      signIn(size);
                    }
                  },
                  icon: const Icon(FontAwesomeIcons.rightToBracket,
                      color: Colors.grey, size: 20),
                  label: Text("Iniciar SesiÓn",
                      style: stylePrincipalBold(13, Colors.grey))),
            ],
          ),
        ),
      ],
    );
  }

  Future signIn(Size size) async {
    loader(context, size);
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _usuarioController.text.toLowerCase().trim(),
              password: _passwordController.text.trim())
          .whenComplete(() => {
                _passwordController.text = "",
                _usuarioController.text = "",
              });
    } on FirebaseAuthException catch (e) {
      setState(() {
        isError = true;
        if (e.code == "wrong-password") {
          error = "Contraseña incorrecta";
          snackbarE(size, context);
        } else if (e.code == "user-not-found") {
          error = "El usuario no existe";
          snackbarE(size, context);
        } else if (e.code == "invalid-email") {
          error = "El correo no es valido";
          snackbarE(size, context);
        }
        Future.delayed(const Duration(milliseconds: 2000), () {
          setState(() {
            isError = false;
          });
        });
      });
    }
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  snackbarE(Size size, BuildContext context) {
    final snackBar = SnackBar(
      content: Container(
        //color: Colors.white,
        height: size.height * 0.1,
        width: Responsive.isDesktop(context)
            ? size.width * 0.35
            : size.width * 0.5,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(14)),
        margin: EdgeInsets.fromLTRB(size.width * 0.4, 0, 0, 15),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                error,
                style: stylePrincipalBold(13, Colors.grey),
              ),
              const Icon(Icons.info, color: Colors.red, size: 22)
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 1000,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
