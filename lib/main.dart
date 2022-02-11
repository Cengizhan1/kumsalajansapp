import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kumsakajansapp/auth_service.dart';
import 'package:kumsakajansapp/connectivity_provider.dart';
import 'package:kumsakajansapp/design/constants.dart';
import 'package:kumsakajansapp/profile_page.dart';
import 'package:kumsakajansapp/wrapper.dart';
import 'package:provider/provider.dart';

import 'design/text_form_decoration.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (context) => ConnectivityProvider(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Wrapper(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController postController = TextEditingController();
  File? image;
  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Consumer<ConnectivityProvider>(builder: (context, model, child) {
    //   if (model.isOnline == false) {
    //     Fluttertoast.showToast(msg: "İnternet Bağlantısı gitti");
    //   }
    // });

    final authService = Provider.of<AuthService>(context);

    final Size size = MediaQuery.of(context).size;

    final ThemeData themeData = Theme.of(context);
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Post")
            .orderBy("tarih", descending: true)
            .snapshots(),
        builder: (context, posts) {
          var post = posts.data!.docs;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: COLOR_WHITE,
              actions: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(primary: COLOR_WHITE),
                  icon: const Icon(
                    Icons.settings,
                    color: COLOR_BLACK,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                  },
                  label: Text(""),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(primary: COLOR_WHITE),
                  icon: const Icon(
                    Icons.logout,
                    color: COLOR_BLACK,
                  ),
                  onPressed: () {
                    authService.signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  label: Text(""),
                ),
              ],
              title: const Text(
                'Ana Sayfa',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                    color: Colors.black),
              ),
            ),
            body: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  BorderBox(
                    child: TextFormField(
                      controller: postController,
                      decoration: const InputDecoration(
                        hintText: "Ne düşünüyorsun...",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Fluttertoast.showToast(
                              msg: "Bu özellik şuan da kapalı");
                        },
                        child: BorderBox(
                          width: size.width / 3,
                          height: 50,
                          child: Icon(Icons.camera_alt),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (postController.text == "") {
                            return;
                          } else {
                            FirebaseFirestore.instance
                                .collection("Person")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .get()
                                .then((value) {
                              var name = value["name"];
                              DateTime now = DateTime.now();
                              String formattedDate =
                                  DateFormat('kk:mm:ss \n EEE d MMM')
                                      .format(now);
                              FirebaseFirestore.instance
                                  .collection("Post")
                                  .doc()
                                  .set({
                                "post": postController.text,
                                "resim":
                                    image != null ? image.toString() : "yok",
                                "name": name,
                                "tarih": formattedDate
                              });
                            });
                          }
                          postController.clear();
                        },
                        child: BorderBox(
                          width: size.width / 3,
                          height: 50,
                          child: Text("Paylaş"),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Text(
                      "Gündem",
                      style: themeData.textTheme.headline4,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Flexible(
                    child: Scrollbar(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: post.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                      color: COLOR_BLACK, width: 2.0)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  onLongPress: () {},
                                  title: Text(
                                    post[index]["name"],
                                    style: themeData.textTheme.bodyText1,
                                    textAlign: TextAlign.start,
                                  ),
                                  subtitle: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 5),
                                      child: Text(
                                        post[index]["post"],
                                        style: themeData.textTheme.bodyText2,
                                      )),
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
