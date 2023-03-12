import 'package:flutter/material.dart';
class RoundButton extends StatelessWidget {
  final String title;
final VoidCallback  onPressed;
  RoundButton({required this.title,required this.onPressed });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: MaterialButton(
        height: 50,
        color: Colors.purple,
        minWidth: double.infinity,
        onPressed: onPressed,
        child: Text(title,style:TextStyle(
          color: Colors.white,
          fontSize: 16
        )),
      )
    );
  }
}
