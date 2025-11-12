import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pingme/app/app.dart';
import 'package:pingme/features/auth/data/auth_repository.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authRepository = AuthRepository();

  runApp(App(authRepository: authRepository));
}
