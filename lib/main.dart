import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_register_ui/api/api.dart';
import 'package:flutter_login_register_ui/api/auth_service.dart';
import 'package:flutter_login_register_ui/l10n/l10n.dart';
import 'package:flutter_login_register_ui/screens/user_mode_wrapper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_locals.dart';
import 'constants.dart';
import './screens/screen.dart';
import './widgets/widget.dart';
import 'firebase_options.dart';
import 'message_handler.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(Firebase.apps.isEmpty)
  await Firebase.initializeApp(
    name: "rpmqa",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (context) => AuthService(firebaseAuth: FirebaseAuth.instance)
        ),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        )
      ],
      child: MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: l10n.all,
        localeListResolutionCallback: (locales, supportedLocales) {
          for (var l in locales)
          for (var supportedLocaleLanguage in supportedLocales) {
              if (supportedLocaleLanguage.languageCode == l.languageCode &&
                              supportedLocaleLanguage.countryCode == l.countryCode) {
                  return supportedLocaleLanguage;
              }
          }
          // If device not support with locale to get language code then default get first on from the list
          return supportedLocales.first;
        },
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'rpmQa',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          scaffoldBackgroundColor: kBackgroundColor,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        //darkTheme: ThemeData.dark(),
        home: MessageHandler(child: AuthenticationWrapper(key: key,)),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {

  AuthenticationWrapper({Key key}) : super(key: key); 

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();
    if(user != null){
      Api api = Api();
      Api.username = user.email;
      return FutureBuilder(
        future: api.getUserMode(user.email),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return UserModeWrapper();
          }
          else return LoadingDialog();
        }
      );
    }
    else return WelcomePage();
  }
}