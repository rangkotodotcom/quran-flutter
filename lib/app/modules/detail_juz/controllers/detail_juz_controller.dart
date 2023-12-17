import 'package:alquran/app/data/models/juz.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class DetailJuzController extends GetxController {
  final player = AudioPlayer();
  Verses? lastVerse;

  void playAudio(Verses ayat) async {
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

  void pauseAudio(Verses ayat) async {
    await player.pause();
    ayat.kondisiAudio = "pause";
    update();
  }

  void resumeAudio(Verses ayat) async {
    ayat.kondisiAudio = "playing";
    update();
    await player.play();
    ayat.kondisiAudio = "stop";
    update();
  }

  void stopAudio(Verses ayat) async {
    await player.stop();
    ayat.kondisiAudio = "stop";
    update();
  }

  @override
  void onClose() {
    player.stop();
    player.dispose();
    super.onClose();
  }
}
