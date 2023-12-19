import 'dart:convert';

import 'package:alquran/app/contants/color.dart';
import 'package:alquran/app/data/db/bookmark.dart';
import 'package:alquran/app/data/models/detail_surah.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sqflite/sqlite_api.dart';

class DetailSurahController extends GetxController {
  AutoScrollController scrollC = AutoScrollController();

  final player = AudioPlayer();
  Verse? lastVerse;

  DatabaseManager database = DatabaseManager.instance;

  Future<void> addBookmark(
      bool lastRead, DetailSurah? surah, Verse ayat, int indexAyat) async {
    Database db = await database.db;

    bool flagExist = false;

    if (lastRead) {
      await db.delete(
        "bookmark",
        where: "last_read=1",
      );
    } else {
      List checkData = await db.query(
        "bookmark",
        where:
            "surah_number='${surah!.number}' and ayat ='${ayat.number!.inSurah}' and juz ='${ayat.meta!.juz}' and via='surah' and index_ayat=$indexAyat and last_read=0",
      );

      if (checkData.isNotEmpty) {
        flagExist = true;
      }
    }

    if (!flagExist) {
      await db.insert(
        "bookmark",
        {
          "surah_number": surah!.number,
          "surah": "${surah.name!.transliteration!.id}",
          "ayat": ayat.number!.inSurah,
          "juz": ayat.meta!.juz,
          "via": "surah",
          "index_ayat": indexAyat,
          "last_read": lastRead ? 1 : 0,
        },
      );
    }

    Get.back();
    Get.snackbar(
      "Berhasil",
      "Berhasil menambahkan Bookmark",
      colorText: appWhite,
    );
  }

  void playAudio(Verse ayat) async {
    if (ayat.audio!.primary != null) {
      lastVerse ??= ayat;

      try {
        lastVerse!.kondisiAudio = "stop";
        lastVerse = ayat;
        lastVerse!.kondisiAudio = "stop";
        update();

        await player.stop();
        await player.setUrl(ayat.audio!.primary.toString());
        ayat.kondisiAudio = 'playing';
        update();
        await player.play();
        ayat.kondisiAudio = 'stop';
        await player.stop();
        update();
      } on PlayerException catch (e) {
        // print("Error code: ${e.code}");
        // print("Error message: ${e.message}");
        Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: e.message.toString(),
        );
      } on PlayerInterruptedException catch (e) {
        Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "Connection aborted: ${e.message.toString()}",
        );
      } catch (e) {
        Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "Tidak dapat memutar audio",
        );
      }
    } else {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Url Audio Tidak Dapat Diakses",
      );
    }
  }

  void pauseAudio(Verse ayat) async {
    await player.pause();
    ayat.kondisiAudio = "pause";
    update();
  }

  void resumeAudio(Verse ayat) async {
    ayat.kondisiAudio = "playing";
    update();
    await player.play();
    ayat.kondisiAudio = "stop";
    update();
  }

  void stopAudio(Verse ayat) async {
    await player.stop();
    ayat.kondisiAudio = "stop";
    update();
  }

  Future<DetailSurah> getDetailSurah(String id) async {
    Uri url = Uri.parse('https://quran-api-sooty.vercel.app/surah/$id');

    var res = await http.get(url);

    Map<String, dynamic> data =
        (jsonDecode(res.body) as Map<String, dynamic>)['data'];

    return DetailSurah.fromJson(data);
  }

  @override
  void onClose() {
    player.stop();
    player.dispose();
    super.onClose();
  }
}
