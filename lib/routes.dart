import 'package:todd_flutter_app/screens/add_screen.dart';
import 'package:todd_flutter_app/screens/login_screen.dart';
import 'package:todd_flutter_app/screens/dashboard_screen.dart';
import 'package:todd_flutter_app/screens/register_screen.dart';
import 'package:todd_flutter_app/screens/settings_screen.dart';
import 'package:todd_flutter_app/screens/placeholder_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:todd_flutter_app/screens/update_screen.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName:(BuildContext context) => LoginScreen(),
  RegisterScreen.routeName:(BuildContext context) => RegisterScreen(),
  DashboardScreen.routeName:(BuildContext context) => DashboardScreen(),
  AddScreen.routeName:(BuildContext context) => AddScreen(),
  SettingsScreen.routeName:(BuildContext context) => SettingsScreen(),
  PlaceholderScreen.routeName:(BuildContext context) => PlaceholderScreen(),
};
