
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WgsvenToast{
   static void showTips(String msg){
     Fluttertoast.showToast(
         msg: msg,
         toastLength: Toast.LENGTH_SHORT,
         gravity: ToastGravity.BOTTOM,
         timeInSecForIosWeb: 1,
         backgroundColor: Colors.white,
         textColor: Colors.black,
         fontSize: 16.0
     );
   }
   static void showError(String msg){
     Fluttertoast.showToast(
         msg: msg,
         toastLength: Toast.LENGTH_SHORT,
         gravity: ToastGravity.BOTTOM,
         timeInSecForIosWeb: 1,
         backgroundColor: Colors.white,
         textColor: Colors.red,
         fontSize: 16.0
     );
  }
}