import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/authentication/data/models/user.dart';

import '../../authentication/data/models/merchant.dart';

class ConstantsManager {
  // static AppUser? appUser;
  static AppUser? appUser = Customer(
    cartItems: {},
    favorites: [],
    orders: [],
    id: "oVtWmHhUWJcVfi7MT1GyVvANHIA2",
    phone: "+2056520552",);
  static String? userId;
  static String? userType;
  // static AppUser? appUser = Merchant(
  //     id: "oVtWmHhUWJcVfi7MT1GyVvANHIA2",
  //     phone: "",
  //     orders: [],
  //     companyName: 'Ahmed',
  //     city: 'Riyadh',
  //     area: '',
  //     registrationNumber: '',
  //     productsIds: []);
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
  static List<String> saudiCitiesEnglish = [
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
}
