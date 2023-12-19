import 'package:alquran/app/contants/color.dart';
import 'package:alquran/app/data/models/detail_surah.dart' as detail;
import 'package:alquran/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../controllers/detail_surah_controller.dart';

// ignore: must_be_immutable
class DetailSurahView extends GetView<DetailSurahController> {
  DetailSurahView({Key? key}) : super(key: key);
  final params = Get.arguments;
  final homeC = Get.find<HomeController>();
  late Map<String, dynamic> bookmark;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Surah ${params['surah'].toString().toUpperCase()}'),
        centerTitle: true,
      ),
      body: FutureBuilder<detail.DetailSurah>(
          future: controller.getDetailSurah(params['number'].toString()),
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

            if (params['bookmark'] != null) {
              bookmark = params['bookmark'];
              controller.scrollC.scrollToIndex(
                bookmark['index_ayat'] + 2,
                preferPosition: AutoScrollPosition.begin,
              );
            }

            detail.DetailSurah surah = snapshot.data!;

            List<Widget> allAyat = List.generate(
              snapshot.data?.verses?.length ?? 0,
              (index) {
                detail.Verse? ayat = snapshot.data?.verses?[index];
                return AutoScrollTag(
                  key: ValueKey(index + 2),
                  index: index + 2,
                  controller: controller.scrollC,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          top: 10,
                        ),
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
                              GetBuilder<DetailSurahController>(
                                builder: (c) => Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Get.defaultDialog(
                                          title: "BOOKMARK",
                                          middleText: "Pilih Jenis Bookmark",
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                await c.addBookmark(
                                                  true,
                                                  snapshot.data,
                                                  ayat!,
                                                  index,
                                                );
                                                homeC.update();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: appPurple,
                                              ),
                                              child: const Text("LAST READ"),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                c.addBookmark(
                                                  false,
                                                  snapshot.data,
                                                  ayat!,
                                                  index,
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: appPurple,
                                              ),
                                              child: const Text("BOOKMARK"),
                                            ),
                                          ],
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.bookmark_add_outlined,
                                      ),
                                    ),
                                    (ayat!.kondisiAudio == 'stop')
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
                                                onPressed: () =>
                                                    c.stopAudio(ayat),
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
                          "${ayat!.text!.arab}",
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontSize: 35,
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
                  ),
                );
              },
            );

            return ListView(
              controller: controller.scrollC,
              padding: const EdgeInsets.all(20),
              children: [
                AutoScrollTag(
                  key: const ValueKey(0),
                  index: 0,
                  controller: controller.scrollC,
                  child: GestureDetector(
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
                                surah.tafsir!.id.toString(),
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
                              "Surah ${surah.name!.transliteration!.id.toString().toUpperCase()}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: appWhite,
                              ),
                            ),
                            Text(
                              "( ${surah.name!.translation!.id.toString().toUpperCase()} )",
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
                              "${surah.numberOfVerses} Ayah | ${surah.revelation!.id}",
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
                ),
                AutoScrollTag(
                  key: const ValueKey(1),
                  index: 1,
                  controller: controller.scrollC,
                  child: const SizedBox(
                    height: 20,
                  ),
                ),
                ...allAyat,
              ],
            );
          }),
    );
  }
}
