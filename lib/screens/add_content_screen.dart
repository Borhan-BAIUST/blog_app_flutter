import 'dart:io';
import 'package:blog_app/components/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddContentScreen extends StatefulWidget {
  const AddContentScreen({Key? key}) : super(key: key);

  @override
  State<AddContentScreen> createState() => _AddContentScreenState();
}

class _AddContentScreenState extends State<AddContentScreen> {
  bool showSpinner = false;
// create reference for Firebasedatabase
  final postRef =FirebaseDatabase.instance.ref().child("posts");
  //who is currently log in or who is user
  final FirebaseAuth _auth =FirebaseAuth.instance;
//firebas storage instance create
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  File? _image;
  //to pickimage
  final picker = ImagePicker();
  final TextEditingController _titleControler = TextEditingController();//textediting controller hold text for user
  final TextEditingController _bodyControler = TextEditingController();
  //image get from gallary  function
  Future getGallaryImage() async {
    //after getting image ,image will store in pickedFile otherwise it will wait
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
      }
    });
  }

  Future getCameraImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
      }
    });
  }

  //pass msz either get image from gallery or using camera
  void dialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: SizedBox(
              height: 120,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      getCameraImage();
                      Navigator.pop(context);
                    },
                    child: const ListTile(
                        leading: Icon(Icons.camera), title: Text("Camera")),
                  ),
                  InkWell(
                    onTap: () {
                      getGallaryImage();
                      Navigator.pop(context);
                    },
                    child: const ListTile(
                        leading: Icon(Icons.photo_library_outlined),
                        title: Text("Gallery")),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create Blogs"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    dialog(context);
                  },
                  child: Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * .3,
                      width: MediaQuery.of(context).size.width,
                      child: _image != null
                          ? ClipRRect(
                              child: Image.file(
                                _image!.absolute,//to get image path
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height * .2,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade300),
                              child: const Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.purple,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                    child: Column(
                  children: [
                    TextFormField(
                      controller: _titleControler,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'Enter Post Title',
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(
                            color: Colors.grey, fontStyle: FontStyle.normal),
                        labelStyle: TextStyle(
                            color: Colors.grey, fontStyle: FontStyle.normal),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _bodyControler,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Enter Description ',
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(
                            color: Colors.grey, fontStyle: FontStyle.normal),
                        labelStyle: TextStyle(
                            color: Colors.grey, fontStyle: FontStyle.normal),
                      ),
                    ),
                    const SizedBox(height: 30),
                    RoundButton(title: "Upload", onPressed: ()async{

                      setState(() {
                        showSpinner = true;
                      });
                      try{
                        int date = DateTime.now().microsecondsSinceEpoch;
                        //create reference for image
                        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/blogapp$date');
                        //upload image using reference
                       UploadTask uploadTask = ref.putFile(_image!.absolute);
                       //wait for uploading image
                       await Future.value(uploadTask);
                       var newUrl = await ref.getDownloadURL();
                       //user will explain who is current user
                       final User? user =_auth.currentUser;

                       postRef.child("Post List").child(date.toString()).set({
                         'pId':date.toString(),
                         'pImage':newUrl.toString(),
                         'pTime':date.toString(),
                         'pTitle':_titleControler.text.toString(),
                         'pDescription':_bodyControler.text.toString(),
                         'uEmail':user!.email.toString(),
                         'uid':user.uid.toString()


                       }).then((value) {
                         toastMessage("Post Published");
                         setState(() {
                           showSpinner=false;
                         });
                       }).onError((error, stackTrace) {
                         showSpinner = false;
                         toastMessage(error.toString());
                       });

                      }catch(e){

                        setState(() {
                          showSpinner = false;
                        });
                        toastMessage(e.toString());
                      }
                    })
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
  void toastMessage(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.purple,
        textColor: Colors.white,
        fontSize: 16.0
    );

  }
}
