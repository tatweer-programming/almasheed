import 'package:almasheed/authentication/data/models/user.dart';
import '../../authentication/data/models/merchant.dart';
import 'localization_manager.dart';

class ConstantsManager {
  static AppUser? appUser;
  static String? userId;
  static String? userType;
  static bool? isNotificationsOn;
  static const String baseUrlNotification =
      "https://fcm.googleapis.com/fcm/send";
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
}
