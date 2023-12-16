import 'package:alquran/app/contants/color.dart';
import 'package:alquran/app/data/models/detail_surah.dart' as detail;
import 'package:alquran/app/data/models/surah.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_surah_controller.dart';

class DetailSurahView extends GetView<DetailSurahController> {
  DetailSurahView({Key? key}) : super(key: key);
  final Surah surah = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Surah ${surah.name.transliteration.id.toUpperCase()}'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GestureDetector(
            onTap: () => Get.dialog(
              Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Get.isDarkMode
                        ? appPurpleLight2.withOpacity(0.3)
                        : appWhite,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Tafsir",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        surah.tafsir.id,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [
                    appPurpleLight1,
                    appPurpleLight2,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      "Surah ${surah.name.transliteration.id.toUpperCase()}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: appWhite,
                      ),
                    ),
                    Text(
                      "( ${surah.name.translation.id.toUpperCase()} )",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: appWhite,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${surah.numberOfVerses} Ayah | ${surah.revelation.id}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: appWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder<detail.DetailSurah>(
              future: controller.getDetailSurah(surah.number.toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("Tidak Ada Data"),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data?.verses?.length ?? 0,
                  itemBuilder: (context, index) {
                    if (snapshot.data!.verses!.isEmpty) {
                      return const SizedBox();
                    }
                    detail.Verse? ayat = snapshot.data?.verses?[index];
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
                                    child: Text("${index + 1}"),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                          Icons.bookmark_add_outlined),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.play_arrow),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "${ayat!.text!.arab}",
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${ayat.text!.transliteration!.en}",
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Text(
                          "${ayat.translation!.id}",
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    );
                  },
                );
              }),
        ],
      ),
    );
  }
}
