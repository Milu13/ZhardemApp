import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zhardem/screens/SplashScreen.dart';
import 'package:zhardem/services/MedicalCardService.dart';
import 'package:zhardem/services/accidentService.dart';
import 'package:zhardem/services/chatService.dart';
import 'package:zhardem/services/phoneNumberAuthService.dart';
import 'package:zhardem/services/placeService.dart';
import 'package:zhardem/services/userService.dart';
import 'package:zhardem/services/usernamePasswordAuthService.dart';

import 'firebase_options.dart';
import 'models/themeModel.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(

    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_)=>ThemeModel() ),
      ChangeNotifierProvider(create: (_)=>UsernamePasswordAuthService()),
      ChangeNotifierProvider(create: (_) => PhoneNumberAuthService()),
      ChangeNotifierProvider(create: (_) => UserService()),
      ChangeNotifierProvider(create: (_) => MedicalCardService()),
      ChangeNotifierProvider(create: (_) =>PlaceService()),
      ChangeNotifierProvider(create: (_) => ChatService()),
      ChangeNotifierProvider(create: (_) =>AccidentService()),
      
    ],
    child: const MyApp(),
    )

  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, theme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Zhardem',
          theme: theme.currentTheme,
          home:  SplashScreen(),
        );
      },
    );
  }
}
