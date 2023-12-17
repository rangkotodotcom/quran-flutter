import 'dart:convert';

import 'package:alquran/app/data/models/detail_surah.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class DetailSurahController extends GetxController {
  final player = AudioPlayer();
  Verse? lastVerse;

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
