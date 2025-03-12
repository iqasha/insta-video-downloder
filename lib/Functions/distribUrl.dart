import 'package:get/get.dart';
import 'package:insta/Functions/insta_download.dart';

class DistribUrl extends GetxController {
  InstaDownloadController instaController = Get.put(InstaDownloadController());
  url(url) {
    RegExp ins = RegExp(r'instagram.com');
    bool test = ins.hasMatch(url);
    if (test) {
      var optIon = url.split("/")[3];
      if (optIon == 'p' || optIon == 'reel') {
        instaController.downloadReal(url);
      } else if (optIon == 'stories') {
        var data = url.split('/');
        RegExp regExp = RegExp(r'^(\d+)');
        var match = regExp.firstMatch(data[5]);
        if (match == null) return;
        instaController.stories(data[4], match.group(0));
      }
    }
  }
}
