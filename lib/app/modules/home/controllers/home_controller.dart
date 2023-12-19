import 'dart:convert';

import 'package:alquran/app/contants/color.dart';
import 'package:alquran/app/data/db/bookmark.dart';
import 'package:alquran/app/data/models/juz.dart';
import 'package:alquran/app/data/models/surah.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

class HomeController extends GetxController {
  RxBool isDark = false.obs;

  DatabaseManager database = DatabaseManager.instance;

  Future<List<Map<String, dynamic>>> getBookmark() async {
    Database db = await database.db;

    List<Map<String, dynamic>> allBookmarks = await db.query(
      "bookmark",
      where: "last_read = 0",
      orderBy: "surah_number",
    );

    return allBookmarks;
  }

  Future<Map<String, dynamic>> getLastRead() async {
    Database db = await database.db;

    List<Map<String, dynamic>> lastRead = await db.query(
      "bookmark",
      where: "last_read = 1",
    );

    if (lastRead.isEmpty) {
      return <String, dynamic>{
        "surah_number": 0,
        "surah": "",
        "juz": "",
        "ayat": "",
      };
    } else {
      return lastRead.first;
    }
  }

  void deleteBookmark(int id) async {
    Database db = await database.db;

    db.delete("bookmark", where: "id = $id");

    Get.snackbar(
      "Berhasil",
      "Bookmark berhasil dihapus",
      colorText: appWhite,
    );
    update();
  }

  void changeThemeMode() async {
    isDark.toggle();
    Get.isDarkMode ? Get.changeTheme(themeLight) : Get.changeTheme(themeDark);

    final box = GetStorage();

    if (Get.isDarkMode) {
      box.remove('themeDark');
    } else {
      box.write("themeDark", true);
    }
  }

  Future<List<Surah>> getAllSurah() async {
    Uri url = Uri.parse('https://quran-api-sooty.vercel.app/surah/');

    var res = await http.get(url);

    List data = (jsonDecode(res.body) as Map<String, dynamic>)['data'];

    if (data.isEmpty) {
      return [];
    } else {
      return data.map((e) => Surah.fromJson(e)).toList();
    }
  }

  Future<List<Juz>> getAllJuz() async {
    List<Juz> allJuz = [];

    for (int i = 1; i <= 30; i++) {
      Uri url = Uri.parse('https://quran-api-sooty.vercel.app/juz/$i');

      var res = await http.get(url);

      Map<String, dynamic> data =
          (jsonDecode(res.body) as Map<String, dynamic>)['data'];

      Juz juz = Juz.fromJson(data);
      allJuz.add(juz);
    }

    return allJuz;
  }

  Future<List<Juz>> getDetailJuz(String juz) async {
    Uri url = Uri.parse('https://quran-api-sooty.vercel.app/juz/$juz');

    var res = await http.get(url);

    List data = (jsonDecode(res.body) as Map<String, dynamic>)['data'];

    if (data.isEmpty) {
      return [];
    } else {
      return data.map((e) => Juz.fromJson(e)).toList();
    }
  }
}
