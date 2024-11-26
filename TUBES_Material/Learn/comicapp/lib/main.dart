import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'comicapp',
    options: Platform.isMacOS || Platform.isIOS
        ? const FirebaseOptions(
            appId: 'IOS KEY',
            apiKey: 'AIzaSyAm_np2W90IG2UD77eyhFUHdraWHjtIwW4',
            projectId: 'comicapp-286b3',
            messagingSenderId: "546354813330",
            databaseURL: 'https://comicapp-286b3.firebaseio.com',
          )
        : const FirebaseOptions(
            appId: '1:546354813330:android:cc4efcdfe8b0b3e6b8894b',
            apiKey: 'AIzaSyAm_np2W90IG2UD77eyhFUHdraWHjtIwW4',
            projectId: 'comicapp-286b3',
            messagingSenderId: "546354813330",
            databaseURL: 'https://comicapp-286b3.firebaseio.com',
          ),
  );

  runApp(ProviderScope(child: MyApp(app: app)));
}

class MyApp extends StatelessWidget {
  final FirebaseApp app;
  const MyApp({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
