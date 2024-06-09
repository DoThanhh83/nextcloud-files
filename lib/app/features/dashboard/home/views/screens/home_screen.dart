library home;

import 'package:disk_space/disk_space.dart';
import 'package:file_man/app/constans/app_constants.dart';
import 'package:file_man/app/features/dashboard/home/views/screens/file_nextcloud.dart';
import 'package:file_man/app/shared_components/custom_button.dart';
import 'package:file_man/app/shared_components/file_list_button.dart';
import 'package:file_man/app/shared_components/header_text.dart';
import 'package:file_man/app/shared_components/search_button.dart';
import 'package:file_man/app/utils/global.dart';
import 'package:file_man/app/utils/helpers/app_helpers.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

// binding
part '../../bindings/home_binding.dart';

// controller
part '../../controllers/home_controller.dart';

// model
part '../../models/usage.dart';

part '../../models/user.dart';

// component
part '../components/category.dart';

part '../components/header.dart';

part '../components/recent.dart';

part '../components/storage_chart.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(kDefaultSpacing),
                  child: _Header(user: controller.user),
                ),
                Padding(
                    padding: const EdgeInsets.all(15),
                    child: Obx(() {
                      // Use Obx to reactively update the UI when _usage changes
                      final usage = controller._usage.value;
                      print(usage.totalFree);
                      return _StorageChart(usage: usage);
                    })),
                // Padding(
                //   padding: const EdgeInsets.all(15),
                //   child: _StorageChart(usage: controller._usage.value),
                // ),
                GestureDetector(
                  onTap: () {
                    // Get.to(() => FileManage());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(kDefaultSpacing),
                    child: _Category(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(kDefaultSpacing),
                  child: _Recent(
                    data: controller.recent,
                  ),
                ),
              ]),
              hasScrollBody: false,
            )
          ],
        ),
      ),
    );
  }
}
