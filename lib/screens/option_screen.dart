import 'package:blog_app/components/round_button.dart';
import 'package:blog_app/screens/log_in_screen.dart';
import 'package:blog_app/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({Key? key}) : super(key: key);

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 30,right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: AssetImage('assets/home_logo.png'),
                //color: Colors.transparent,
              ),
              const SizedBox(height: 30,),
              RoundButton(title: "Log In", onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const LogInScreen()));
              }),
              const SizedBox(height: 30,),
              RoundButton(title: 'Register', onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=> const SignInScreen()));

              })
            ],
          ),
        ),
      )
    );
  }
}
