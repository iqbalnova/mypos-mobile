import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'features/core/app.dart';
import 'features/core/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}
