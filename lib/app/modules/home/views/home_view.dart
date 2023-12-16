import 'package:alquran/app/contants/color.dart';
import 'package:alquran/app/data/models/surah.dart';
import 'package:alquran/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (Get.isDarkMode) {
      controller.isDark.value = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Quran'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.SEARCH),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Assalamu'alaikum",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [
                      appPurpleLight1,
                      appPurpleLight2,
                    ],
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () => Get.toNamed(Routes.LAST_READ),
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: -50,
                          right: 0,
                          child: Opacity(
                            opacity: 0.6,
                            child: SizedBox(
                              width: 200,
                              height: 200,
                              child: Image.asset(
                                "assets/images/alquran.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.menu_book_rounded,
                                    color: appWhite,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Terakhir dibaca",
                                    style: TextStyle(
                                      color: appWhite,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Al-Fatihah",
                                style: TextStyle(
                                  color: appWhite,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "Juz 1 | Ayat 5",
                                style: TextStyle(
                                  color: appWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const TabBar(
                tabs: [
                  Tab(
                    text: "Surah",
                  ),
                  Tab(
                    text: "Juz",
                  ),
                  Tab(
                    text: "Bookmark",
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    FutureBuilder<List<Surah>>(
                      future: controller.getAllSurah(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Surah surah = snapshot.data![index];
                            return ListTile(
                              onTap: () => Get.toNamed(
                                Routes.DETAIL_SURAH,
                                arguments: surah,
                              ),
                              leading: Obx(() => Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          controller.isDark.isTrue
                                              ? "assets/images/list_dark.png"
                                              : "assets/images/list_light.png",
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "${surah.number}",
                                        style: TextStyle(
                                          color: Get.isDarkMode
                                              ? appWhite
                                              : appPurpleDark,
                                        ),
                                      ),
                                    ),
                                  )),
                              title: Text(
                                surah.name.transliteration.id,
                              ),
                              subtitle: Text(
                                "${surah.numberOfVerses} Ayat | ${surah.revelation.id}",
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              trailing: Text(
                                surah.name.short,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    ListView.builder(
                      itemCount: 30,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {},
                          leading: Obx(() => Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      controller.isDark.isTrue
                                          ? "assets/images/list_dark.png"
                                          : "assets/images/list_light.png",
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "${index + 1}",
                                    style: TextStyle(
                                      color: Get.isDarkMode
                                          ? appWhite
                                          : appPurpleDark,
                                    ),
                                  ),
                                ),
                              )),
                          title: Text(
                            "Juz ${index + 1}",
                          ),
                        );
                      },
                    ),
                    const Center(
                      child: Text('Page 3'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.isDarkMode
              ? Get.changeTheme(themeLight)
              : Get.changeTheme(themeDark);
          controller.isDark.toggle();
        },
        child: Obx(() => Icon(
              Icons.color_lens_rounded,
              color: controller.isDark.isTrue ? appWhite : appPurpleDark,
            )),
      ),
    );
  }
}
