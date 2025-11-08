// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'किसानवर्स';

  @override
  String get home => 'होम';

  @override
  String get crops => 'फसलें';

  @override
  String get inventory => 'इन्वेंटरी';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get fetchingLocation => 'स्थान प्राप्त कर रहे हैं...';

  @override
  String get fetchingWeather => 'मौसम की जानकारी प्राप्त कर रहे हैं...';

  @override
  String get locationPermissionDenied =>
      'स्थान अनुमति अस्वीकृत। कृपया सेटिंग्स में सक्षम करें।';

  @override
  String get errorGettingLocation => 'स्थान प्राप्त करने में त्रुटि';

  @override
  String get unableToFetchWeather => 'मौसम की जानकारी प्राप्त करने में असमर्थ';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get manageYourFields => 'अपने खेतों का प्रबंधन करें';

  @override
  String get myFarm => 'मेरा खेत';

  @override
  String get balance => 'शेष राशि';

  @override
  String get humidity => 'आर्द्रता';

  @override
  String get soilMoisture => 'मिट्टी की नमी';

  @override
  String get precipitation => 'वर्षा';

  @override
  String get low => 'कम';

  @override
  String get good => 'अच्छा';

  @override
  String get high => 'उच्च';

  @override
  String get dry => 'सूखा';

  @override
  String get wet => 'गीला';

  @override
  String get none => 'कोई नहीं';

  @override
  String get medium => 'मध्यम';

  @override
  String get cropsManagement => 'फसल प्रबंधन';

  @override
  String get manageYourCropsHere => 'यहाँ अपनी फसलों का प्रबंधन करें';

  @override
  String get trackYourInventoryHere => 'यहाँ अपनी इन्वेंटरी ट्रैक करें';

  @override
  String get welcomeTitle => 'स्वागत है!';

  @override
  String get welcomeSubtitle => 'आइए आपको बेहतर तरीके से जानें';

  @override
  String get contactInformation => 'संपर्क जानकारी';

  @override
  String get contactSubtitle => 'हम आपसे कैसे संपर्क कर सकते हैं?';

  @override
  String get farmDetails => 'खेत का विवरण';

  @override
  String get farmDetailsSubtitle => 'हमें अपने खेत के बारे में बताएं';

  @override
  String stepOf(int current, int total) {
    return 'चरण $current का $total';
  }

  @override
  String get yourFullName => 'आपका पूरा नाम';

  @override
  String get namePlaceholder => 'उदा., राजेश कुमार';

  @override
  String get farmName => 'खेत का नाम';

  @override
  String get farmNamePlaceholder => 'उदा., ओकडेल रैंच';

  @override
  String get emailAddress => 'ईमेल पता';

  @override
  String get emailPlaceholder => 'उदा., farmer@example.com';

  @override
  String get phoneNumber => 'फ़ोन नंबर';

  @override
  String get phonePlaceholder => 'उदा., +91 98765 43210';

  @override
  String get farmLocation => 'खेत का स्थान';

  @override
  String get locationPlaceholder => 'उदा., उप्पल कलां, तेलंगाना';

  @override
  String get farmSize => 'खेत का आकार';

  @override
  String get farmSizePlaceholder => 'उदा., 50 एकड़';

  @override
  String get yearsOfExperience => 'अनुभव के वर्ष';

  @override
  String get experiencePlaceholder => 'उदा., 15 वर्ष';

  @override
  String get back => 'पीछे';

  @override
  String get continueButton => 'जारी रखें';

  @override
  String get completeSetup => 'सेटअप पूरा करें';

  @override
  String get pleaseEnterYourName => 'कृपया अपना नाम दर्ज करें';

  @override
  String get pleaseEnterFarmName => 'कृपया खेत का नाम दर्ज करें';

  @override
  String get pleaseEnterEmail => 'कृपया अपना ईमेल दर्ज करें';

  @override
  String get pleaseEnterValidEmail => 'कृपया एक मान्य ईमेल दर्ज करें';

  @override
  String get pleaseEnterPhone => 'कृपया अपना फ़ोन नंबर दर्ज करें';

  @override
  String get pleaseEnterLocation => 'कृपया अपने खेत का स्थान दर्ज करें';

  @override
  String get pleaseEnterFarmSize => 'कृपया अपने खेत का आकार दर्ज करें';

  @override
  String get pleaseEnterExperience => 'कृपया अपना अनुभव दर्ज करें';

  @override
  String get pleaseFillAllFields => 'कृपया सभी आवश्यक फ़ील्ड भरें';

  @override
  String get email => 'ईमेल';

  @override
  String get phone => 'फ़ोन';

  @override
  String get location => 'स्थान';

  @override
  String get experience => 'अनुभव';

  @override
  String get notAvailable => 'उपलब्ध नहीं';

  @override
  String get nextGenFarming1 => 'खेती की अगली पीढ़ी 1';

  @override
  String get nextGenFarming2 => 'खेती की अगली पीढ़ी 2';

  @override
  String get nextGenFarming3 => 'खेती की अगली पीढ़ी 3';

  @override
  String get nextGenFarming4 => 'खेती की अगली पीढ़ी 4';

  @override
  String get farmingDescription =>
      'हम डेटा प्रदान करते हैं जो वैश्विक कृषि के लक्ष्यों को सक्षम बनाता है।';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get language => 'भाषा';

  @override
  String get selectLanguage => 'भाषा चुनें';
}
