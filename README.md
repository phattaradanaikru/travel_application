# Travel Application

แอปพลิเคชันท่องเที่ยวที่พัฒนาด้วย [Flutter](https://flutter.dev) สำหรับค้นหาสถานที่ท่องเที่ยว บันทึกสถานที่ที่ชอบ และวางแผนทริปลงในปฏิทินส่วนตัว โดยดึงข้อมูลสถานที่ท่องเที่ยวจาก TAT Data API (Tourism Authority of Thailand) และใช้ Firebase สำหรับระบบสมาชิกและจัดเก็บข้อมูลผู้ใช้

## ฟีเจอร์หลัก

- **สมาชิก (Authentication)** — สมัครสมาชิกและเข้าสู่ระบบด้วยอีเมล/รหัสผ่านผ่าน Firebase Authentication
- **สำรวจสถานที่ (Explore)** — ค้นหาและแสดงรายการสถานที่ท่องเที่ยวจาก TAT Data API พร้อมหน้ารายละเอียดสถานที่ (รูปภาพ, ข้อมูลทั่วไป)
- **รายการที่ชอบ (Whitelist/Favorites)** — บันทึกสถานที่ที่สนใจไว้ดูภายหลัง โดยข้อมูลจะถูกซิงค์เก็บไว้ใน Cloud Firestore ของผู้ใช้แต่ละคน
- **ปฏิทินทริป (Trips/Calendar)** — เพิ่ม/จัดการกำหนดการเดินทางลงในปฏิทิน (ใช้ `table_calendar`) และซิงค์ข้อมูลผ่าน Firestore
- **ตั้งค่า (Settings)** — สลับธีมโหมดสว่าง/มืด (Light/Dark mode) และออกจากระบบ

## เทคโนโลยีที่ใช้

| หมวดหมู่ | เครื่องมือ/ไลบรารี |
|---|---|
| Framework | Flutter (Dart SDK `^3.7.2`) |
| State Management | `provider` |
| Backend / Auth | Firebase (`firebase_core`, `firebase_auth`, `cloud_firestore`) |
| ข้อมูลสถานที่ท่องเที่ยว | [TAT Data API](https://tatdataapi.io) ผ่าน `dio` |
| ปฏิทิน | `table_calendar` |
| เก็บข้อมูลในเครื่อง | `shared_preferences` |
| ไอคอน | `font_awesome_flutter`, `cupertino_icons` |
| อื่น ๆ | `intl`, `flutter_dotenv` |

## โครงสร้างโปรเจกต์

```
lib/
├── components/        # วิดเจ็ตย่อยที่ใช้ซ้ำในแต่ละหน้า (calendar, detail, explore)
├── data/
│   ├── model/          # โมเดลข้อมูล (สถานที่, รายละเอียดสถานที่, อีเวนต์ทริป)
│   └── services/        # service layer (API, Auth, Calendar, Favorite, Theme)
├── page/                # หน้าจอหลักของแอป (Home, Login, Register, Explore, Detail, Whitelist, Calendar, Setting)
├── theme/               # ธีมสีและการตกแต่งของแอป
├── firebase_options.dart
└── main.dart            # จุดเริ่มต้นของแอป
```

แอปรองรับการ build บนแพลตฟอร์ม **Android, iOS, Web, Windows, macOS และ Linux** (มีโฟลเดอร์ของแต่ละแพลตฟอร์มอยู่แล้วในโปรเจกต์)

## เริ่มต้นใช้งาน (Getting Started)

### สิ่งที่ต้องมีก่อน

- ติดตั้ง [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart `^3.7.2` หรือใหม่กว่า)
- มีบัญชี [Firebase](https://firebase.google.com/) สำหรับสร้างโปรเจกต์ของตัวเอง
- มี API Key ของ [TAT Data API](https://tatdataapi.io) (สมัครขอคีย์ได้จากเว็บไซต์ TAT Data API)

### การติดตั้ง

1. โคลนโปรเจกต์

   ```bash
   git clone https://github.com/phattaradanaikru/travel_application.git
   cd travel_application
   ```

2. ติดตั้ง dependencies

   ```bash
   flutter pub get
   ```

3. ตั้งค่า Firebase

   โปรเจกต์ใช้ Firebase Authentication และ Cloud Firestore จึงต้องเชื่อมต่อกับโปรเจกต์ Firebase ของคุณเอง โดยใช้ [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup):

   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

   คำสั่งนี้จะสร้างไฟล์ `lib/firebase_options.dart` รวมถึงไฟล์คอนฟิกของแต่ละแพลตฟอร์ม (เช่น `google-services.json` สำหรับ Android และ `GoogleService-Info.plist` สำหรับ iOS) ให้อัตโนมัติ และต้องเปิดใช้งาน **Email/Password Authentication** และ **Cloud Firestore** ในคอนโซลของ Firebase ด้วย

4. ตั้งค่า API Key ของ TAT Data API

   ปัจจุบันคีย์ของ TAT Data API ถูกกำหนดไว้ใน `lib/data/services/apiservices.dart` ให้แก้ไขค่า `x-api-key` เป็นคีย์ของคุณเอง สำหรับการใช้งานจริงแนะนำให้ย้ายค่านี้ไปเก็บผ่านไฟล์ `.env` (โปรเจกต์มีไลบรารี `flutter_dotenv` เตรียมไว้แล้ว) แทนการฝังคีย์ไว้ในซอร์สโค้ดตรง ๆ

5. รันแอป

   ```bash
   flutter run
   ```

   หรือเลือกแพลตฟอร์มที่ต้องการรัน เช่น

   ```bash
   flutter run -d chrome     # สำหรับเว็บ
   flutter run -d windows    # สำหรับ Windows
   ```
