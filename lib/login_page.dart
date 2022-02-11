import 'package:flutter/material.dart';
import 'package:kumsakajansapp/auth_service.dart';
import 'package:kumsakajansapp/design/constants.dart';
import 'package:kumsakajansapp/main.dart';
import 'package:provider/provider.dart';

import 'design/text_form_decoration.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    final Size size = MediaQuery.of(context).size;

    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: COLOR_WHITE,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: size.height / 8,
            ),
            Text(
              "Giriş",
              textAlign: TextAlign.center,
              style: themeData.textTheme.headline2,
            ),
            SizedBox(
              height: size.height / 10,
            ),
            BorderBox(
              width: size.width - 30,
              height: 60,
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.mail,
                    color: COLOR_GREY,
                  ),
                  hintText: "E-mail",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            BorderBox(
              width: size.width - 30,
              height: 60,
              child: TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.vpn_key,
                    color: COLOR_GREY,
                  ),
                  hintText: "Şifre",
                  prefixText: " ",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                authService.signInWithEmailandPassword(
                    emailController.text, passwordController.text);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: BorderBox(
                width: size.width / 3,
                height: 50,
                child: Text("Giriş"),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterPage()));
              },
              child: BorderBox(
                width: size.width / 3,
                height: 50,
                child: Text("Kayıt ol"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    final Size size = MediaQuery.of(context).size;

    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: COLOR_WHITE,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: size.height / 8,
            ),
            Text(
              "Kayıt ol",
              textAlign: TextAlign.center,
              style: themeData.textTheme.headline2,
            ),
            SizedBox(
              height: size.height / 10,
            ),
            BorderBox(
              width: size.width - 30,
              height: 60,
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
                    color: COLOR_GREY,
                  ),
                  hintText: "Ad",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            BorderBox(
              width: size.width - 30,
              height: 60,
              child: TextFormField(
                controller: surnameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
                    color: COLOR_GREY,
                  ),
                  hintText: "Soy ad",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            BorderBox(
              width: size.width - 30,
              height: 60,
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.mail,
                    color: COLOR_GREY,
                  ),
                  hintText: "E-mail",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            BorderBox(
              width: size.width - 30,
              height: 60,
              child: TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.vpn_key,
                    color: COLOR_GREY,
                  ),
                  hintText: "Şifre",
                  prefixText: " ",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: BorderBox(
                width: size.width / 3,
                height: 50,
                child: Text("Giriş"),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                authService.createPerson(
                  nameController.text,
                  emailController.text,
                  passwordController.text,
                  surnameController.text,
                );
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: BorderBox(
                width: size.width / 3,
                height: 50,
                child: Text("Kayıt ol"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
