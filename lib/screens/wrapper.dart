import 'package:bur_crew/models/appUser.dart';
import 'package:bur_crew/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'authenticate/authenticate.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<appUser>(context);
    // return either the Home or Authenticate widget

    return user==null ? Authenticate() : Home();

  }
} 