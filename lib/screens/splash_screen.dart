import 'dart:async';

import 'package:blog_app/screens/home_screen.dart';
import 'package:blog_app/screens/option_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final user = auth.currentUser;
    if(user != null){
      Timer(const Duration(seconds: 2),()=>
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const HomeScreen())));
    }else{
      Timer(const Duration(seconds: 2), ()=>
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const OptionScreen())));
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(image: const AssetImage(
            "assets/home_logo.png"
          ),
         // height: MediaQuery.of(context).size.height *.4,
          width: MediaQuery.of(context).size.width * .6,
          fit: BoxFit.cover,),
          const Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text("Blog !",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 30,
                fontStyle: FontStyle.italic,
                color: Colors.purple
              ),
              ),
            ),
          )
        ],
      ) ,
    );
  }
}
