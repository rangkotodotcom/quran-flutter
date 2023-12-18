import 'package:alquran/app/contants/color.dart';
import 'package:alquran/app/data/models/juz.dart' as juz;
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_juz_controller.dart';

class DetailJuzView extends GetView<DetailJuzController> {
  DetailJuzView({Key? key}) : super(key: key);
  final juz.Juz detailJuz = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JUZ ${detailJuz.juz}'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: detailJuz.verses!.length,
        itemBuilder: (context, index) {
          juz.Verses ayat = detailJuz.verses![index];
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: appPurpleLight2.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage(
                            Get.isDarkMode
                                ? "assets/images/list_dark.png"
                                : "assets/images/list_light.png",
                          ),
                          fit: BoxFit.contain,
                        )),
                        child: Center(
                          child: Text("${ayat.number!.inSurah}"),
                        ),
                      ),
                      GetBuilder<DetailJuzController>(
                        builder: (c) => Row(
                          children: [
                            (ayat.kondisiAudio == 'stop')
                                ? IconButton(
                                    onPressed: () => c.playAudio(ayat),
                                    icon: const Icon(
                                      Icons.play_arrow,
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      (ayat.kondisiAudio == 'playing')
                                          ? IconButton(
                                              onPressed: () =>
                                                  c.pauseAudio(ayat),
                                              icon: const Icon(
                                                Icons.pause,
                                              ),
                                            )
                                          : IconButton(
                                              onPressed: () =>
                                                  c.resumeAudio(ayat),
                                              icon: const Icon(
                                                Icons.play_arrow,
                                              ),
                                            ),
                                      IconButton(
                                        onPressed: () => c.stopAudio(ayat),
                                        icon: const Icon(
                                          Icons.stop,
                                        ),
                                      )
                                    ],
                                  ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: Get.width,
                padding: const EdgeInsets.only(
                  left: 20,
                ),
                child: Text(
                  "${ayat.text!.arab}",
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: Get.width,
                child: Text(
                  "${ayat.text!.transliteration!.en}",
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: Get.width,
                child: Text(
                  "${ayat.translation!.id}",
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          );
        },
      ),
    );
  }
}
