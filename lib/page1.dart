import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:juinstagram/add_page.dart';
import 'package:juinstagram/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'device.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: Device.w / 2.1,
              color: Colors.amber,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${FirebaseAuth.instance.currentUser!.email}"),
                  ),
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text("Something went wrong");
                      }

                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return const Text("Document does not exist");
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return Text("Full Name: ${data['fullname']}");
                      }

                      return const Text("loading");
                    },
                  )
                ],
              )),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              title: const Text("LogOut"),
              leading: const Icon(Icons.logout),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Select Language | اختر اللغه'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('عربي'),
                          onPressed: () {
                            Navigator.of(context).pop();


                            SharedPreferences.getInstance().then((value) {

                              value.setString("lang", "ar");
                            });

                            context.setLocale(Locale('ar', 'JO'));
                          },
                        ),
                        TextButton(
                          child: const Text('English'),
                          onPressed: () {
                            Navigator.of(context).pop();

                            SharedPreferences.getInstance().then((value) {

                              value.setString("lang", "en");
                            });
                            context.setLocale(Locale('en', 'JO'));
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              title: const Text("Change Language"),
              leading: const Icon(Icons.language),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("JuInstagram"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddPage(null)));
              },
              icon: Icon(
                Icons.add,
                size: Device.w / 15,
              ))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("posts").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              String documentId = document.id;

              return
                  //    data["owner"]!=FirebaseAuth.instance.currentUser!.email?SizedBox():

                  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          data["owner"],
                        ),
                        leading: FirebaseAuth.instance.currentUser!.email ==
                                data["owner"]
                            ? IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => AddPage({
                                            "image": data["image"],
                                            "content": data["content"],
                                            'id': documentId
                                          })));
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.amber,
                                ),
                              )
                            : const SizedBox(),
                        trailing: FirebaseAuth.instance.currentUser!.email ==
                                data["owner"]
                            ? IconButton(
                                onPressed: () {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'Are you sure to delete this post!'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('yes'),
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection("posts")
                                                  .doc(documentId)
                                                  .delete();

                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                ),
                              )
                            : const SizedBox(),
                      ),
                      data["image"] == ''
                          ? const SizedBox()
                          : Image.network(data["image"]),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data["content"],
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
