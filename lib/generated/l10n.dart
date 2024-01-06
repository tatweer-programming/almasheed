// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Add Category`
  String get addCategory {
    return Intl.message(
      'Add Category',
      name: 'addCategory',
      desc: '',
      args: [],
    );
  }

  /// `Add Image`
  String get addImage {
    return Intl.message(
      'Add Image',
      name: 'addImage',
      desc: '',
      args: [],
    );
  }

  /// `Add Product`
  String get addProduct {
    return Intl.message(
      'Add Product',
      name: 'addProduct',
      desc: '',
      args: [],
    );
  }

  /// `Add To Cart`
  String get addToCart {
    return Intl.message(
      'Add To Cart',
      name: 'addToCart',
      desc: '',
      args: [],
    );
  }

  /// `I Agree to`
  String get agreeTo {
    return Intl.message(
      'I Agree to',
      name: 'agreeTo',
      desc: '',
      args: [],
    );
  }

  /// `Alphabet`
  String get alphabet {
    return Intl.message(
      'Alphabet',
      name: 'alphabet',
      desc: '',
      args: [],
    );
  }

  /// `Already have account ?`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have account ?',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Area`
  String get area {
    return Intl.message(
      'Area',
      name: 'area',
      desc: '',
      args: [],
    );
  }

  /// `Best Sales`
  String get bestSales {
    return Intl.message(
      'Best Sales',
      name: 'bestSales',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Cart`
  String get cart {
    return Intl.message(
      'Cart',
      name: 'cart',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }
  /// `Favourites`
  String get favourites {
    return Intl.message(
      'Favourites',
      name: 'favourites',
      desc: '',
      args: [],
    );
  }

  /// `The Category has been added successfully`
  String get categoryAdded {
    return Intl.message(
      'The Category has been added successfully',
      name: 'categoryAdded',
      desc: '',
      args: [],
    );
  }

  /// `please choose account type`
  String get chooseAccountType {
    return Intl.message(
      'please choose account type',
      name: 'chooseAccountType',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message(
      'City',
      name: 'city',
      desc: '',
      args: [],
    );
  }

  /// `Company name`
  String get companyName {
    return Intl.message(
      'Company name',
      name: 'companyName',
      desc: '',
      args: [],
    );
  }

  /// `Create your account now`
  String get createYourAccountNow {
    return Intl.message(
      'Create your account now',
      name: 'createYourAccountNow',
      desc: '',
      args: [],
    );
  }

  /// `Customer`
  String get customer {
    return Intl.message(
      'Customer',
      name: 'customer',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Didn't receive the code?`
  String get didNotReceiveCode {
    return Intl.message(
      'Didn\'t receive the code?',
      name: 'didNotReceiveCode',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discount {
    return Intl.message(
      'Discount',
      name: 'discount',
      desc: '',
      args: [],
    );
  }

  /// `You don't have an account ?`
  String get doNotHaveAccount {
    return Intl.message(
      'You don\'t have an account ?',
      name: 'doNotHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `you should enter all SMS code`
  String get enterAllCode {
    return Intl.message(
      'you should enter all SMS code',
      name: 'enterAllCode',
      desc: '',
      args: [],
    );
  }

  /// `please enter area name`
  String get enterArea {
    return Intl.message(
      'please enter area name',
      name: 'enterArea',
      desc: '',
      args: [],
    );
  }

  /// `please enter city name`
  String get enterCity {
    return Intl.message(
      'please enter city name',
      name: 'enterCity',
      desc: '',
      args: [],
    );
  }

  /// `please enter company name`
  String get enterCompanyName {
    return Intl.message(
      'please enter company name',
      name: 'enterCompanyName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a name`
  String get enterName {
    return Intl.message(
      'Please enter a name',
      name: 'enterName',
      desc: '',
      args: [],
    );
  }

  /// `please enter phone number`
  String get enterPhone {
    return Intl.message(
      'please enter phone number',
      name: 'enterPhone',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a price`
  String get enterPrice {
    return Intl.message(
      'Please enter a price',
      name: 'enterPrice',
      desc: '',
      args: [],
    );
  }

  /// `please enter registration number`
  String get enterRegistration {
    return Intl.message(
      'please enter registration number',
      name: 'enterRegistration',
      desc: '',
      args: [],
    );
  }

  /// `Please select a category`
  String get enterSelectedCategory {
    return Intl.message(
      'Please select a category',
      name: 'enterSelectedCategory',
      desc: '',
      args: [],
    );
  }

  /// `Enter the code sent to `
  String get enterSentCode {
    return Intl.message(
      'Enter the code sent to ',
      name: 'enterSentCode',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'enterTheCodeSentTo ' key

  /// `Please enter a valid discount from 0% to 100%`
  String get enterValidDiscount {
    return Intl.message(
      'Please enter a valid discount from 0% to 100%',
      name: 'enterValidDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Evaluation`
  String get evaluation {
    return Intl.message(
      'Evaluation',
      name: 'evaluation',
      desc: '',
      args: [],
    );
  }

  /// `Highest to lowest price`
  String get highestToLowestPrice {
    return Intl.message(
      'Highest to lowest price',
      name: 'highestToLowestPrice',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Login as merchant`
  String get loginAsMerchant {
    return Intl.message(
      'Login as merchant',
      name: 'loginAsMerchant',
      desc: '',
      args: [],
    );
  }

  /// `Login now`
  String get loginNow {
    return Intl.message(
      'Login now',
      name: 'loginNow',
      desc: '',
      args: [],
    );
  }

  /// `Lowest to highest price`
  String get lowestToHighestPrice {
    return Intl.message(
      'Lowest to highest price',
      name: 'lowestToHighestPrice',
      desc: '',
      args: [],
    );
  }

  /// `Merchant`
  String get merchant {
    return Intl.message(
      'Merchant',
      name: 'merchant',
      desc: '',
      args: [],
    );
  }

  /// `Merchants`
  String get merchants {
    return Intl.message(
      'Merchants',
      name: 'merchants',
      desc: '',
      args: [],
    );
  }

  /// `Modify Product`
  String get modifyProduct {
    return Intl.message(
      'Modify Product',
      name: 'modifyProduct',
      desc: '',
      args: [],
    );
  }

  /// `You must agree to the terms and conditions`
  String get mustAgreeToTerms {
    return Intl.message(
      'You must agree to the terms and conditions',
      name: 'mustAgreeToTerms',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `There is no items here`
  String get noItems {
    return Intl.message(
      'There is no items here',
      name: 'noItems',
      desc: '',
      args: [],
    );
  }

  /// `Not Found`
  String get notFound {
    return Intl.message(
      'Not Found',
      name: 'notFound',
      desc: '',
      args: [],
    );
  }

  /// `Offers`
  String get offers {
    return Intl.message(
      'Offers',
      name: 'offers',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Order by ..`
  String get orderBy {
    return Intl.message(
      'Order by ..',
      name: 'orderBy',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number Verification`
  String get phoneNumberVerification {
    return Intl.message(
      'Phone Number Verification',
      name: 'phoneNumberVerification',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `The product has been added successfully`
  String get productAdded {
    return Intl.message(
      'The product has been added successfully',
      name: 'productAdded',
      desc: '',
      args: [],
    );
  }

  /// `Product Category`
  String get productCategory {
    return Intl.message(
      'Product Category',
      name: 'productCategory',
      desc: '',
      args: [],
    );
  }

  /// `The product has been modified successfully`
  String get productModified {
    return Intl.message(
      'The product has been modified successfully',
      name: 'productModified',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }
  /// `Quantity`
  String get quantity {
    return Intl.message(
      'Quantity',
      name: 'quantity',
      desc: '',
      args: [],
    );
  }

  /// `RESEND`
  String get reSend {
    return Intl.message(
      'RESEND',
      name: 'reSend',
      desc: '',
      args: [],
    );
  }

  /// `Register now`
  String get registerNow {
    return Intl.message(
      'Register now',
      name: 'registerNow',
      desc: '',
      args: [],
    );
  }

  /// `Registration number`
  String get registrationNumber {
    return Intl.message(
      'Registration number',
      name: 'registrationNumber',
      desc: '',
      args: [],
    );
  }

  /// `SAR`
  String get sar {
    return Intl.message(
      'SAR',
      name: 'sar',
      desc: '',
      args: [],
    );
  }

  /// `search ...`
  String get search {
    return Intl.message(
      'search ...',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Seller`
  String get seller {
    return Intl.message(
      'Seller',
      name: 'seller',
      desc: '',
      args: [],
    );
  }

  /// `Send code`
  String get sendCode {
    return Intl.message(
      'Send code',
      name: 'sendCode',
      desc: '',
      args: [],
    );
  }

  /// `Sign in now`
  String get signInNow {
    return Intl.message(
      'Sign in now',
      name: 'signInNow',
      desc: '',
      args: [],
    );
  }

  /// `Sort by city`
  String get sortByCity {
    return Intl.message(
      'Sort by city',
      name: 'sortByCity',
      desc: '',
      args: [],
    );
  }

  /// `Support`
  String get support {
    return Intl.message(
      'Support',
      name: 'support',
      desc: '',
      args: [],
    );
  }

  /// `Terms & conditions`
  String get termsAndConditions {
    return Intl.message(
      'Terms & conditions',
      name: 'termsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `- The AlMasheed platform is dedicated to facilitating the purchasing process and communication between the customer and the facility owner. To complete the purchase, the platform deducts a nominal amount from the purchase value as a fee for platform services and as a non-refundable deposit upon order completion.\n- Customers have the right to communicate with the facility owner (the seller) for inquiries and to finalize or cancel purchase orders based on their mutual agreement. It is important to note that the platform is not responsible for any financial or other disputes that may arise between the customer and the facility owner.\n- If a customer wishes to cancel an order before receiving it, they must contact the facility owner and inform them. In the event that the order reaches the customer and they decide to cancel it, the customer is responsible for the cost of transporting the purchased items from the delivery location to the facility owner's premises or as otherwise agreed upon.\n- The platform reserves the right to delete or suspend the activities of any customer violating the platform's policies through any means, including fraudulent orders and lack of seriousness in placing orders. Customers can also communicate with the facility owner in case of any comments or concerns related to the order.\n- The AlMasheed platform retains the terms and conditions, prohibiting the trading or dissemination of these terms through any means.\n- Approved communication channels within the platform:\n  - Email: almasheed-1380@hotmail.com\n  - WhatsApp: 0537014738`
  String get termsToCustomer {
    return Intl.message(
      '- The AlMasheed platform is dedicated to facilitating the purchasing process and communication between the customer and the facility owner. To complete the purchase, the platform deducts a nominal amount from the purchase value as a fee for platform services and as a non-refundable deposit upon order completion.\n- Customers have the right to communicate with the facility owner (the seller) for inquiries and to finalize or cancel purchase orders based on their mutual agreement. It is important to note that the platform is not responsible for any financial or other disputes that may arise between the customer and the facility owner.\n- If a customer wishes to cancel an order before receiving it, they must contact the facility owner and inform them. In the event that the order reaches the customer and they decide to cancel it, the customer is responsible for the cost of transporting the purchased items from the delivery location to the facility owner\'s premises or as otherwise agreed upon.\n- The platform reserves the right to delete or suspend the activities of any customer violating the platform\'s policies through any means, including fraudulent orders and lack of seriousness in placing orders. Customers can also communicate with the facility owner in case of any comments or concerns related to the order.\n- The AlMasheed platform retains the terms and conditions, prohibiting the trading or dissemination of these terms through any means.\n- Approved communication channels within the platform:\n  - Email: almasheed-1380@hotmail.com\n  - WhatsApp: 0537014738',
      name: 'termsToCustomer',
      desc: '',
      args: [],
    );
  }

  /// `- The AlMasheed platform is dedicated to facilitating the purchasing process and communication between the customer and the facility owner in a clear and simple manner, while saving effort and time for both parties.\n- Upon completing a purchase order from the customer, the platform deducts a nominal fee not exceeding 10% of the purchase value as a platform fee and a non-refundable deposit upon order completion.\n- The facility owner is committed to providing the order to the customer accurately, including quality, material safety, and delivery speed as agreed upon between them.\n- There is room for communication between the customer and the service provider to agree on purchase details such as purchase requests, total cost calculation, delivery method, and other matters related to purchase orders.\n- The customer has the right to cancel the order before receiving it by contacting the facility owner, and in case of receiving the order and wishing to cancel it, the customer is obliged to pay the transportation cost from the place of receipt to the facility owner's location or as agreed upon between them.\n- AlMasheed's goal is to facilitate communication between the parties, and it is not responsible for any disputes between the customer and the facility owner, including financial disputes and others, including but not limited to: inaccuracies in the order, delivery-related errors causing damage to purchase orders, and others.\n- The platform has the right to delete or suspend the activity of any facility that violates the platform's policies by any means. Facility owners can contact the support team in case of any issues related to platform services.\n- AlMasheed retains the terms and conditions outlined and prohibits the circulation or publication of these terms in any way.\n- The approved communication channels within the platform:\n   Email: almasheed-1380@hotmail.com\n   WhatsApp: 0537014738`
  String get termsToMerchant {
    return Intl.message(
      '- The AlMasheed platform is dedicated to facilitating the purchasing process and communication between the customer and the facility owner in a clear and simple manner, while saving effort and time for both parties.\n- Upon completing a purchase order from the customer, the platform deducts a nominal fee not exceeding 10% of the purchase value as a platform fee and a non-refundable deposit upon order completion.\n- The facility owner is committed to providing the order to the customer accurately, including quality, material safety, and delivery speed as agreed upon between them.\n- There is room for communication between the customer and the service provider to agree on purchase details such as purchase requests, total cost calculation, delivery method, and other matters related to purchase orders.\n- The customer has the right to cancel the order before receiving it by contacting the facility owner, and in case of receiving the order and wishing to cancel it, the customer is obliged to pay the transportation cost from the place of receipt to the facility owner\'s location or as agreed upon between them.\n- AlMasheed\'s goal is to facilitate communication between the parties, and it is not responsible for any disputes between the customer and the facility owner, including financial disputes and others, including but not limited to: inaccuracies in the order, delivery-related errors causing damage to purchase orders, and others.\n- The platform has the right to delete or suspend the activity of any facility that violates the platform\'s policies by any means. Facility owners can contact the support team in case of any issues related to platform services.\n- AlMasheed retains the terms and conditions outlined and prohibits the circulation or publication of these terms in any way.\n- The approved communication channels within the platform:\n   Email: almasheed-1380@hotmail.com\n   WhatsApp: 0537014738',
      name: 'termsToMerchant',
      desc: '',
      args: [],
    );
  }

  /// `verify`
  String get verify {
    return Intl.message(
      'verify',
      name: 'verify',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to almasheed`
  String get welcomeToAlmasheed {
    return Intl.message(
      'Welcome to almasheed',
      name: 'welcomeToAlmasheed',
      desc: '',
      args: [],
    );
  }

  /// `You must determine quantity`
  String get determineQuantity {
    return Intl.message(
      'You must determine quantity',
      name: 'determineQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Code Verified Successfully`
  String get codeVerified {
    return Intl.message(
      'Code Verified Successfully',
      name: 'codeVerified',
      desc: '',
      args: [],
    );
  }

  /// `User not found`
  String get userNotFound {
    return Intl.message(
      'User not found',
      name: 'userNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Code Sent Successfully`
  String get codeSent {
    return Intl.message(
      'Code Sent Successfully',
      name: 'codeSent',
      desc: '',
      args: [],
    );
  }

  /// `user created Successfully`
  String get userCreated {
    return Intl.message(
      'user created Successfully',
      name: 'userCreated',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
