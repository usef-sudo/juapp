import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:juinstagram/login_screen.dart';
import 'package:juinstagram/themeprovider.dart';
import 'package:provider/provider.dart';
import 'device.dart';
import 'firebase_options.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences.getInstance().then((value) {
    Device.lang = value.getString("lang") ?? "en";
  });

  runApp(ChangeNotifierProvider(
    create: (_) => ThemeProvider(true),
    child: EasyLocalization(
        supportedLocales: [Locale('en', 'JO'), Locale('ar', 'JO')],
        path: 'lib/assets/translation', //

        fallbackLocale: Locale(Device.lang, 'JO'),
        child: JuInstagram()),
  ));
}

class JuInstagram extends StatelessWidget {
  const JuInstagram({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    Device.h = MediaQuery.of(context).size.height;
    Device.w = MediaQuery.of(context).size.width; //411
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: themeProvider.themeData(),
      home: LoginPage(),
      routes: {LoginPage.route: (context) => LoginPage()},
    );
  }
}
