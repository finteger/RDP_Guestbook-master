import 'package:flutter/material.dart';

import 'package:flutter_project/screens/home.dart';
import 'package:flutter_project/screens/aboutUs.dart';
import 'package:flutter_project/screens/contactUs.dart';

const String aboutUs = 'About Us';
const String homePage = 'Home Page';
const String contactUs = 'Contact Us';

Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case homePage:
      return MaterialPageRoute(builder: (context) => HomePage());
    case aboutUs:
      return MaterialPageRoute(builder: (context) => AboutUs());
    case contactUs:
      return MaterialPageRoute(builder: (context) => ContactUs());
    default:
      throw ('This route name does not exist!');
  }
}
