
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_locals_ar.dart';
import 'app_locals_en.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations returned
/// by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'gen_l10n/app_locals.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// No description provided for @welcomeback.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeback;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'username'**
  String get username;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Dont\'t have an account?'**
  String get dont;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get instagram;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Twitter'**
  String get twitter;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'TikTok'**
  String get tikTok;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsApp;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Report Preview'**
  String get reportPreview;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Choose your situation'**
  String get chooseyoursituation;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Stuck in sand'**
  String get stuckinsand;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Drowning'**
  String get drowning;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Out of fuel'**
  String get outoffuel;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Flat tire'**
  String get flattire;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Overturned'**
  String get overturned;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Battery charging'**
  String get batterycharging;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Switch to volunteer account?'**
  String get switchtovolunteeraccount;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'situation'**
  String get situation;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'snapshot of situation'**
  String get snapshotofsituation;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Take a snapshot'**
  String get takeasnapshot;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Create a new account to get started'**
  String get createanewaccount;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Volunteer'**
  String get volunteer;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Equipped car photo'**
  String get equippedcarphoto;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get already;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signin;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'New Emergency'**
  String get emergency;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get waiting;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'New phone'**
  String get newphone;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Confirm changes'**
  String get confirmch;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteacc;

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
