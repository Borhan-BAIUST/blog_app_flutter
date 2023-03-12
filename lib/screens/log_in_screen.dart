import 'package:blog_app/screens/forgot_password_screen.dart';
import 'package:blog_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/round_button.dart';
class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String email = '', password = '';
  bool showSpinner = false;
  final FirebaseAuth _auth =FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Welcome to Log In',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          backgroundColor: Colors.purple,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Log In",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
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
                      TextFormField(
                        obscureText: true,
                        controller: _passwordController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            hintText: 'Password',
                            prefix: Icon(
                              Icons.lock,
                              color: Colors.purple,
                            )),
                        onChanged: (String value) {
                          password = value;
                        },
                        validator: (value) {
                          return value!.isEmpty ? 'Enter Password' : null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                       InkWell(
                         onTap: (){
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>const ForgetPasswordScreen()));
                         },
                         child: const Align(
                             alignment: Alignment.centerRight,
                             child: Text("Forget Password ?",style: (
                             TextStyle(
                               color: Colors.redAccent
                             )
                             ),)),
                       ),
                      const SizedBox(
                        height: 15,
                      ),
                      RoundButton(title: 'Log In', onPressed: () async{
                        if(_formKey.currentState!.validate()){
                          setState(() {
                            showSpinner=true;
                          });
                          try{
                            final user = await _auth.signInWithEmailAndPassword(email: email.toString().trim(),
                                password: password.toString().trim());
                            if(user != null){
                              toastMessage('User Succesfully Log In');
                              setState(() {
                                showSpinner=false;
                              });
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
                            }

                          }catch(e){
                            toastMessage(e.toString());
                            setState(() {
                              showSpinner=false;
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
