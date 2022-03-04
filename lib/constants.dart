import 'package:flutter/material.dart';

// Colors
const kBackgroundColor = Color(0xff191720);
const kTextFieldFill = Color(0xff1E1C24);

// TextStyles
const kHeadline = TextStyle(
  color: Colors.white,
  fontSize: 34,
  fontWeight: FontWeight.bold,
);

const kBodyText = TextStyle(
  color: Colors.grey,
  fontSize: 15,
);

const kButtonText = TextStyle(
  color: Colors.black87,
  fontSize: 16,
  fontWeight: FontWeight.bold,
);

const situations = {1:"Stuck in sand",2:"Drowning",3:"Out of fuel",4:"Flat tire",5:"Overturned" ,6: "Battery Charging"};

const kBodyText2 = TextStyle(fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white);

const cardTitleText = TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white);

const cardBodyText = TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white);

const errorText = TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.red);

const lang= {
  "Welcome back!" : "!مرحبا بعودتك",
  "username" : "اسم المستخدم",
  "Password" : "كلمة المرور",
  "Dont't have an account?" : "ليس لديك حساب؟",
  "Register" : "سجل الان",
  "Sign In" :  "تسجيل الدخول",
  "Contact Us" : "للتواصل بنا",
  "Instagram": "الانستغرام",
  "Facebook": "الفيسبوك",
  "Twitter": "تويتر",
  "TikTok": "تيك توك",
  "WhatsApp":"الواتساب",
  "Email: Support@rpm.qa" :"البريد الإلكتروني",
  "Report Preview" : "معاينة التقرير",
  "Home" : "الصفحة الرئيسية",
  "Choose your situation" :"اختر نوع البلاغ",
  "Stuck in sand" : "مركبة مغرزة",
  "Drowning" : "مركبة غرقانة",
  "Out of fuel" : "نفاذ الوقود",
  "Flat tire" : "تاير مبنشر",
  "Overturned" : "مركبة مقلوبة",
  "Battery charging" : "شحن بطارية",
  "Switch to volunteer account?": "قم بالتبديل إلى حسابي التطوعي؟",
  "Logout" : "تسجيل الخروج",
  "situation":"نوع البلاغ",
  "snapshot of situation": "إثبات للبلاغ",
  "Take a snapshot" : "تصوير إثبات البلاغ",
  "Create a new account to get started" : "قم بإنشاء حساب جديد",
  "Customer" : "حساب عميل",
  "Volunteer" : "متطوع",
  "Name" : "الاسم ",
  "Phone" : "رقم الهاتف",
  "Equipped car photo" : "صورة من المركبة المجهزة للطرق الوعرة",
  "Already have an account?" : "هل لديك حساب؟ ",
  "Create new account to get started" : "قم بإنشاء حساب جديد",
  "Sign in" : "تسجيل الدخول",
  "Submit" : "تقديم البلاغ"
};