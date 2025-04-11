import 'package:casha/casha_app.dart';
import 'package:casha/core/dependancy_injection.dart';
import 'package:flutter/material.dart';

void main() async {
  await DependencyInjection.init();
  runApp(CashaApp());
}
