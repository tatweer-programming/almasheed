import 'package:almasheed/authentication/data/models/user.dart';
import 'package:multi_dropdown/models/value_item.dart';

import 'localization_manager.dart';

class ConstantsManager {
  static AppUser? appUser;
  static bool? registrationSkipped;
  static String? userId;
  static String? userType;
  static bool? isNotificationsOn;
  static String whatsappSupport = "00966537014738";
  static String paymentToken =
      "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL";
  static const String baseUrlNotification =
      "https://fcm.googleapis.com/fcm/send";
  static const String successUrl =
      "https://firebasestorage.googleapis.com/v0/b/masheed-d942d.appspot.com/o/payment%2Fsuccess%20(2).HTML?alt=media&token=2d979a52-9247-4abd-a264-fba2d5f0ae2e";
  static const String errorUrl =
      "https://firebasestorage.googleapis.com/v0/b/masheed-d942d.appspot.com/o/payment%2Ffailed.HTML?alt=media&token=01fddc6e-e292-4080-bddb-0e3fa4f54993";
  static const String firebaseMessagingAPI =
      "AAAAg2F4b1U:APA91bEp1nenkuZMlwu3PmiNRJTWOiG4zncmBF_23UiLcdtm42HZ1lDaoR-sRP21PFquem76ZHVKj5wGXI76Mx6WvqgUS2xxFAjuvM0hBMMd8cNvDcLEH6XKc65wBk_3C4IRr5znOi1M";

  // static AppUser? appUser = Merchant(
  //     id: "oVtWmHhUWJcVfi7MT1GyVvANHIA2",
  //     phone: "",
  //     orders: [],
  //     area: "",
  //     city: "",
  //     companyName: "Ahmed",
  //     productsIds: ["2023-12-25 16:26:42.710784"],
  //     registrationNumber: "");
  // static AppUser? appUser =
  //     Customer(cartItems: {}, favorites: [], orders: [], addresses: [
  //   Address(
  //       street: "شارع فلان الفلاني ",
  //       city: "جدة",
  //       houseNumber: 1,
  //       floor: 1,
  //       apartmentNumber: 2,
  //       area: "منطقة كذا",
  //       plot: "القطعة الفلانية",
  //       avenue: "الجادة الفلانية",
  //       type: "عنوان منزل")
  // ], id: "u8BNEWaq4OPE0vogmtJDi0IBUMp1", phone: "");

  static final List<String> saudiCitiesArabic = [
    'الرياض',
    'جدة',
    'مكة المكرمة',
    'الدمام',
    'الخبر',
    'الطائف',
    'المدينة المنورة',
    'بريدة',
    'تبوك',
    'خميس مشيط',
    'حائل',
    'الجبيل',
    'الخرج',
    'أبها',
    'نجران',
    'ينبع',
    'القصيم',
    'الظهران',
    'الباحة',
    'الأحساء',
    'النماص',
    'عرعر',
    'سكاكا',
    'جازان',
    'عنيزة',
    'القريات',
    'الرس',
    'صفوى',
    'الخفجي',
    'الدوادمي',
    'الزلفي',
    'رفحاء',
    'شقراء',
    'الدرعية',
    'الرميلة',
    'بيشة',
    'الطائف',
    'الظهران',
    'الفرسان',
    'المظيلف',
    'المزاحمية',
    'المويه',
  ];
  static final List<String> saudiCitiesEnglish = [
    'Riyadh',
    'Jeddah',
    'Mecca',
    'Dammam',
    'Khobar',
    'Taif',
    'Medina',
    'Buraydah',
    'Tabuk',
    'Khamis Mushait',
    'Hail',
    'Jubail',
    'Kharg',
    'Abha',
    'Najran',
    'Yanbu',
    'Qassim',
    'Dhahran',
    'Baha',
    'Al Ahsa',
    'Namas',
    'Arar',
    'Sakakah',
    'Jazan',
    'Unaizah',
    'Qurayyat',
    'Ar Rass',
    'Safwa',
    'Khafji',
    'Ad Dawadimi',
    'Zulfi',
    'Rafha',
    'Shaqraa',
    'Ad Diriyah',
    'Ar Rumaylah',
    'Bisha',
    'Taif',
    'Dhahran',
    'Farasan',
    'Muzahmiyya',
    'Al Muwayh',
  ];

  static List<String> get getSaudiCities {
    if (LocalizationManager.getCurrentLocale().languageCode == "ar") {
      return saudiCitiesArabic;
    } else {
      return saudiCitiesEnglish;
    }
  }

  static ValueItem<String> convertWorkToEnglish(ValueItem<String> work) {
    int index = worksArabic.indexOf(work);
    return (index != -1) ? worksEnglish[index] : work;
  }

  static ValueItem<String> convertWorkToArabic(ValueItem<String> work) {
    int index = worksEnglish.indexOf(work);
    return (index != -1) ? worksArabic[index] : work;
  }

  static const List<ValueItem<String>> worksEnglish = [
    ValueItem(label: "Electricity technician", value: "Electricity technician"),
    ValueItem(label: "Plumbing", value: "Plumbing"),
    ValueItem(label: "Paint", value: "Paint"),
    ValueItem(label: "Tile", value: "Tile"),
    ValueItem(
        label: "Air conditioning technician",
        value: "Air conditioning technician"),
    ValueItem(label: "Carpenter", value: "Carpenter"),
    ValueItem(label: "Smith", value: "Smith"),
    ValueItem(label: "Another", value: "Another"),
  ];
  static const List<ValueItem<String>> worksArabic = [
    ValueItem(label: "فني كهرباء", value: "فني كهرباء"),
    ValueItem(label: "سباكة", value: "سباكة"),
    ValueItem(label: "دهان", value: "دهان"),
    ValueItem(label: "بليط", value: "بليط"),
    ValueItem(label: "فني تكييف", value: "فني تكييف"),
    ValueItem(label: "نجار", value: "نجار"),
    ValueItem(label: "حداد", value: "حداد"),
    ValueItem(label: "أخري", value: "أخري"),
  ];

  static List<ValueItem<String>> get getWorks {
    if (LocalizationManager.getCurrentLocale().languageCode == "ar") {
      return worksArabic;
    } else {
      return worksEnglish;
    }
  }
}
