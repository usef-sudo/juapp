import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'device.dart';

class AddPage extends StatefulWidget {
  final Map<String, dynamic>? data;
  const AddPage(this.data, {super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.data != null) {
      _imageController.text = widget.data!["image"];
      _contentController.text = widget.data!["content"];
    }
  }

  XFile? image = null;

  String? link = null;

  final storageRef = FirebaseStorage.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data != null ? "Edit post" : "Add Post"),
      ),
      body: Column(
        children: [
          image != null
              ? GestureDetector(
                  child: CircleAvatar(
                    backgroundImage: FileImage(
                      File(
                        image!.path,
                      ),
                    ),
                    minRadius: 100,
                  ),
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('pick image from:'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Gallery'),
                              onPressed: () async {
                                Navigator.of(context).pop();

                                image = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                setState(() {});
                              },
                            ),
                            TextButton(
                              child: const Text('Camera'),
                              onPressed: () async {
                                Navigator.of(context).pop();

                                image = await ImagePicker()
                                    .pickImage(source: ImageSource.camera);
                                setState(() {});
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              : widget.data != null
                  ? GestureDetector(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(_imageController.text),
                        minRadius: 100,
                      ),
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('pick image from:'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Gallery'),
                                  onPressed: () async {
                                    Navigator.of(context).pop();

                                    image = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);
                                    setState(() {});
                                  },
                                ),
                                TextButton(
                                  child: const Text('Camera'),
                                  onPressed: () async {
                                    Navigator.of(context).pop();

                                    image = await ImagePicker()
                                        .pickImage(source: ImageSource.camera);
                                    setState(() {});
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    )
                  : IconButton(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('pick image from:'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Gallery'),
                                  onPressed: () async {
                                    Navigator.of(context).pop();

                                    image = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);
                                    setState(() {});
                                  },
                                ),
                                TextButton(
                                  child: const Text('Camera'),
                                  onPressed: () async {
                                    Navigator.of(context).pop();

                                    image = await ImagePicker()
                                        .pickImage(source: ImageSource.camera);
                                    setState(() {});
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon:  Icon(
                        Icons.add_a_photo_outlined,
                        size: Device.w/2.7,
                      )),

          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     controller: _imageController,
          //     decoration: InputDecoration(
          //       hintText: 'Add Post Image Link (optional)',
          //       contentPadding:
          //           EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.all(Radius.circular(32.0)),
          //       ),
          //       enabledBorder: OutlineInputBorder(
          //         borderSide:
          //             BorderSide(color: Colors.lightBlueAccent, width: 1.0),
          //         borderRadius: BorderRadius.all(Radius.circular(32.0)),
          //       ),
          //       focusedBorder: OutlineInputBorder(
          //         borderSide:
          //             BorderSide(color: Colors.lightBlueAccent, width: 2.0),
          //         borderRadius: BorderRadius.all(Radius.circular(32.0)),
          //       ),
          //     ),
          //   ),
          // ), //todo: add image link
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLines: 5,
              controller: _contentController,
              decoration: const InputDecoration(
                hintText: 'Enter your Post Content',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
            ),
          ), // todo add post content

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: ElevatedButton(
                    onPressed: () async {
                      try {
                        FirebaseStorage storage = FirebaseStorage.instance;
                        Reference storageReference = storage.ref().child(
                            'uploads/${DateTime.now().millisecondsSinceEpoch}');
                        UploadTask uploadTask =
                            storageReference.putFile(File(image!.path));
                        TaskSnapshot snapshot = await uploadTask;
                        String downloadUrl =
                            await snapshot.ref.getDownloadURL();
                        link = downloadUrl;
                      } catch (e) {
                        print("Error uploading file: $e");
                        link = "null";
                      }

                      Map<String, dynamic> data = {
                        "image": link,
                        "content": _contentController.text,
                        "dateTime": DateTime.now(),
                        "owner": FirebaseAuth.instance.currentUser!.email
                      };

                      if (widget.data != null) {
                        FirebaseFirestore.instance
                            .collection("posts")
                            .doc(widget.data!["id"])
                            .update(data);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Post edited successfully"),
                          duration: Duration(milliseconds: 1000),
                        ));
                      } else {
                        FirebaseFirestore.instance
                            .collection("posts")
                            .doc()
                            .set(data);

                        setState(() {
                          _imageController.clear();
                          _contentController.clear();
                          image = null;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Post added successfully"),
                          duration: Duration(milliseconds: 1000),
                        ));
                      }
                    },
                    child:
                        Text(widget.data != null ? "Edit Post" : "Add Post"))),
          )
        ],
      ),
    );
  }
}
