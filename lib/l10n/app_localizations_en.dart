// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Kisanverse';

  @override
  String get home => 'Home';

  @override
  String get crops => 'Crops';

  @override
  String get inventory => 'Inventory';

  @override
  String get profile => 'Profile';

  @override
  String get fetchingLocation => 'Fetching location...';

  @override
  String get fetchingWeather => 'Fetching weather...';

  @override
  String get locationPermissionDenied =>
      'Location permission denied. Please enable in settings.';

  @override
  String get errorGettingLocation => 'Error getting location';

  @override
  String get unableToFetchWeather => 'Unable to fetch weather';

  @override
  String get retry => 'Retry';

  @override
  String get manageYourFields => 'Manage your fields';

  @override
  String get myFarm => 'My Farm';

  @override
  String get balance => 'Balance';

  @override
  String get humidity => 'Humidity';

  @override
  String get soilMoisture => 'Soil Moisture';

  @override
  String get precipitation => 'Precipitation';

  @override
  String get low => 'Low';

  @override
  String get good => 'Good';

  @override
  String get high => 'High';

  @override
  String get dry => 'Dry';

  @override
  String get wet => 'Wet';

  @override
  String get none => 'None';

  @override
  String get medium => 'Medium';

  @override
  String get cropsManagement => 'Crops Management';

  @override
  String get manageYourCropsHere => 'Manage your crops here';

  @override
  String get trackYourInventoryHere => 'Track your inventory here';

  @override
  String get welcomeTitle => 'Welcome!';

  @override
  String get welcomeSubtitle => 'Let\'s start by knowing you better';

  @override
  String get contactInformation => 'Contact Information';

  @override
  String get contactSubtitle => 'How can we reach you?';

  @override
  String get farmDetails => 'Farm Details';

  @override
  String get farmDetailsSubtitle => 'Tell us about your farm';

  @override
  String stepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get yourFullName => 'Your Full Name';

  @override
  String get namePlaceholder => 'e.g., John Doe';

  @override
  String get farmName => 'Farm Name';

  @override
  String get farmNamePlaceholder => 'e.g., Oakdale Ranch';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get emailPlaceholder => 'e.g., farmer@example.com';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phonePlaceholder => 'e.g., +1 234 567 8900';

  @override
  String get farmLocation => 'Farm Location';

  @override
  String get locationPlaceholder => 'e.g., Uppal Kalan, Telangana';

  @override
  String get farmSize => 'Farm Size';

  @override
  String get farmSizePlaceholder => 'e.g., 50 Acres';

  @override
  String get yearsOfExperience => 'Years of Experience';

  @override
  String get experiencePlaceholder => 'e.g., 15 Years';

  @override
  String get back => 'Back';

  @override
  String get continueButton => 'Continue';

  @override
  String get completeSetup => 'Complete Setup';

  @override
  String get pleaseEnterYourName => 'Please enter your name';

  @override
  String get pleaseEnterFarmName => 'Please enter your farm name';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email';

  @override
  String get pleaseEnterPhone => 'Please enter your phone number';

  @override
  String get pleaseEnterLocation => 'Please enter your farm location';

  @override
  String get pleaseEnterFarmSize => 'Please enter your farm size';

  @override
  String get pleaseEnterExperience => 'Please enter your experience';

  @override
  String get pleaseFillAllFields => 'Please fill all required fields';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Phone';

  @override
  String get location => 'Location';

  @override
  String get experience => 'Experience';

  @override
  String get notAvailable => 'N/A';

  @override
  String get nextGenFarming1 => 'The next generation of farming 1';

  @override
  String get nextGenFarming2 => 'The next generation of farming 2';

  @override
  String get nextGenFarming3 => 'The next generation of farming 3';

  @override
  String get nextGenFarming4 => 'The next generation of farming 4';

  @override
  String get farmingDescription =>
      'We provide data that enables the goals of global agriculture.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';
}
