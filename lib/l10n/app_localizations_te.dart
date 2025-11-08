// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'కిసాన్‌వర్స్';

  @override
  String get home => 'హోమ్';

  @override
  String get crops => 'పంటలు';

  @override
  String get inventory => 'ఇన్వెంటరీ';

  @override
  String get profile => 'ప్రొఫైల్';

  @override
  String get fetchingLocation => 'స్థానం పొందుతోంది...';

  @override
  String get fetchingWeather => 'వాతావరణ సమాచారం పొందుతోంది...';

  @override
  String get locationPermissionDenied =>
      'స్థానం అనుమతి తిరస్కరించబడింది. దయచేసి సెట్టింగ్స్‌లో ప్రారంభించండి.';

  @override
  String get errorGettingLocation => 'స్థానం పొందడంలో లోపం';

  @override
  String get unableToFetchWeather => 'వాతావరణ సమాచారం పొందలేకపోయింది';

  @override
  String get retry => 'మళ్లీ ప్రయత్నించండి';

  @override
  String get manageYourFields => 'మీ పొలాలను నిర్వహించండి';

  @override
  String get myFarm => 'నా పొలం';

  @override
  String get balance => 'బ్యాలెన్స్';

  @override
  String get humidity => 'తేమ';

  @override
  String get soilMoisture => 'నేల తేమ';

  @override
  String get precipitation => 'వర్షపాతం';

  @override
  String get low => 'తక్కువ';

  @override
  String get good => 'మంచిది';

  @override
  String get high => 'అధికం';

  @override
  String get dry => 'పొడి';

  @override
  String get wet => 'తడి';

  @override
  String get none => 'ఏదీ లేదు';

  @override
  String get medium => 'మధ్యస్థం';

  @override
  String get cropsManagement => 'పంటల నిర్వహణ';

  @override
  String get manageYourCropsHere => 'ఇక్కడ మీ పంటలను నిర్వహించండి';

  @override
  String get trackYourInventoryHere => 'ఇక్కడ మీ ఇన్వెంటరీని ట్రాక్ చేయండి';

  @override
  String get welcomeTitle => 'స్వాగతం!';

  @override
  String get welcomeSubtitle => 'మిమ్మల్ని బాగా తెలుసుకుందాం';

  @override
  String get contactInformation => 'సంప్రదింపు సమాచారం';

  @override
  String get contactSubtitle => 'మేము మిమ్మల్ని ఎలా చేరుకోవచ్చు?';

  @override
  String get farmDetails => 'పొలం వివరాలు';

  @override
  String get farmDetailsSubtitle => 'మీ పొలం గురించి మాకు చెప్పండి';

  @override
  String stepOf(int current, int total) {
    return 'దశ $current యొక్క $total';
  }

  @override
  String get yourFullName => 'మీ పూర్తి పేరు';

  @override
  String get namePlaceholder => 'ఉదా., రాజేష్ కుమార్';

  @override
  String get farmName => 'పొలం పేరు';

  @override
  String get farmNamePlaceholder => 'ఉదా., ఓక్‌డేల్ రాంచ్';

  @override
  String get emailAddress => 'ఇమెయిల్ చిరునామా';

  @override
  String get emailPlaceholder => 'ఉదా., farmer@example.com';

  @override
  String get phoneNumber => 'ఫోన్ నంబర్';

  @override
  String get phonePlaceholder => 'ఉదా., +91 98765 43210';

  @override
  String get farmLocation => 'పొలం స్థానం';

  @override
  String get locationPlaceholder => 'ఉదా., ఉప్పల్ కలాన్, తెలంగాణ';

  @override
  String get farmSize => 'పొలం పరిమాణం';

  @override
  String get farmSizePlaceholder => 'ఉదా., 50 ఎకరాలు';

  @override
  String get yearsOfExperience => 'అనుభవ సంవత్సరాలు';

  @override
  String get experiencePlaceholder => 'ఉదా., 15 సంవత్సరాలు';

  @override
  String get back => 'వెనుకకు';

  @override
  String get continueButton => 'కొనసాగించు';

  @override
  String get completeSetup => 'సెటప్ పూర్తి చేయండి';

  @override
  String get pleaseEnterYourName => 'దయచేసి మీ పేరు నమోదు చేయండి';

  @override
  String get pleaseEnterFarmName => 'దయచేసి పొలం పేరు నమోదు చేయండి';

  @override
  String get pleaseEnterEmail => 'దయచేసి మీ ఇమెయిల్ నమోదు చేయండి';

  @override
  String get pleaseEnterValidEmail =>
      'దయచేసి చెల్లుబాటు అయ్యే ఇమెయిల్ నమోదు చేయండి';

  @override
  String get pleaseEnterPhone => 'దయచేసి మీ ఫోన్ నంబర్ నమోదు చేయండి';

  @override
  String get pleaseEnterLocation => 'దయచేసి మీ పొలం స్థానం నమోదు చేయండి';

  @override
  String get pleaseEnterFarmSize => 'దయచేసి మీ పొలం పరిమాణం నమోదు చేయండి';

  @override
  String get pleaseEnterExperience => 'దయచేసి మీ అనుభవం నమోదు చేయండి';

  @override
  String get pleaseFillAllFields => 'దయచేసి అవసరమైన అన్ని ఫీల్డ్‌లను పూరించండి';

  @override
  String get email => 'ఇమెయిల్';

  @override
  String get phone => 'ఫోన్';

  @override
  String get location => 'స్థానం';

  @override
  String get experience => 'అనుభవం';

  @override
  String get notAvailable => 'అందుబాటులో లేదు';

  @override
  String get nextGenFarming1 => 'వ్యవసాయం యొక్క తదుపరి తరం 1';

  @override
  String get nextGenFarming2 => 'వ్యవసాయం యొక్క తదుపరి తరం 2';

  @override
  String get nextGenFarming3 => 'వ్యవసాయం యొక్క తదుపరి తరం 3';

  @override
  String get nextGenFarming4 => 'వ్యవసాయం యొక్క తదుపరి తరం 4';

  @override
  String get farmingDescription =>
      'మేము ప్రపంచ వ్యవసాయ లక్ష్యాలను సాధ్యం చేసే డేటాను అందిస్తాము.';

  @override
  String get getStarted => 'ప్రారంభించండి';

  @override
  String get language => 'భాష';

  @override
  String get selectLanguage => 'భాషను ఎంచుకోండి';
}
