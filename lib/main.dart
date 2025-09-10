import 'package:bookapp/features/auth/controller/auth_controller.dart';
import 'package:bookapp/firebase_options.dart';
import 'package:bookapp/features/routes/app_routes.dart';
import 'package:bookapp/features/theme/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthController()); // Initialize AuthController for GetX
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.whiteColor,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/onboarding',
  getPages: AppRoutes.routes,
    // home: SignUpScreen()
    );
  }
}


