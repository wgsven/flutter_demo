

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class SplashLoading extends StatefulWidget{
  @override
  _SplashLoadingState createState() => _SplashLoadingState();
}

class _SplashLoadingState extends State<SplashLoading>{
  @override
  Widget build(BuildContext context) {
    return new FlareActor("intro.flr",alignment:Alignment.center, fit:BoxFit.contain, animation:"1");
  }
}
