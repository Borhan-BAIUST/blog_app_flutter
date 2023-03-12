import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/round_button.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  bool showSpinner = false;
  //auth for firebase
  final FirebaseAuth _auth =FirebaseAuth.instance;
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Forget Password',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          backgroundColor: Colors.purple,
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            hintText: 'Email',
                            prefix: Icon(
                              Icons.email,
                              color: Colors.purple,
                            )),
                        onChanged: (String value) {
                          email = value;
                        },
                        validator: (value) {
                          return value!.isEmpty ? 'Enter Email Address' : null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      RoundButton(title: 'Recover password', onPressed: ()async{
                        if (_formKey.currentState!.validate()){
                          setState(() {
                            showSpinner= true;
                          });
                          try{
                            _auth.sendPasswordResetEmail(email:_emailController.text.toString()).then((value) {
                              setState(() {
                                showSpinner = false;
                              });
                              toastMessage("Please chechk your email to reset Your password");

                            }).onError((error, stackTrace){
                              toastMessage(error.toString());
                              setState(() {
                                showSpinner = false;
                              });
                            });
                          }catch(e){
                            toastMessage(e.toString());
                            setState(() {
                              showSpinner = false;
                            });
                          }
                        }
                      })
                    ],
                  ))
            ],
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
