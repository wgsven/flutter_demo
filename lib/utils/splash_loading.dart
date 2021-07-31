

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget{
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading>{
  @override
  Widget build(BuildContext context) {
    return new FlareActor("intro.flr",alignment:Alignment.center, fit:BoxFit.contain, animation:"1");
  }
}
