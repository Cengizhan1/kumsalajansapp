import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'design/text_form_decoration.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    final Size size = MediaQuery.of(context).size;

    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height / 6,
            ),
            Text(
              "Profil",
              textAlign: TextAlign.center,
              style: themeData.textTheme.headline2,
            ),
            SizedBox(
              height: 50,
            ),
            BorderBox(
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: "Yeni nick",
                  prefixText: " ",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              width: size.width - 20,
              height: 60,
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                FirebaseFirestore.instance
                    .collection("Person")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .update({"name": nameController.text});
                Fluttertoast.showToast(msg: "Nick başarı ile güncellenmiştir");
              },
              child: BorderBox(
                width: size.width / 3,
                height: 50,
                child: Text("Güncelle"),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                await FirebaseFirestore.instance
                    .collection("Person")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .delete();
                try {
                  await FirebaseAuth.instance.currentUser!.delete();
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'requires-recent-login') {
                    print(
                        'The user must reauthenticate before this operation can be executed.');
                  }
                }
                Fluttertoast.showToast(msg: "Hesap başarı ile silinmiştir");

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: BorderBox(
                width: size.width / 3,
                height: 50,
                child: Text("Hesabı sil"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
