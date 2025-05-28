import 'package:actual/common/const/data.dart';

class DataUtils {
  //JsonKey값은 static 필수
  static String pathToUrl(String value) {
    return 'http://$ip$value';
  }

  static List<String> listPathToUrls(List paths) {
    return paths.map((e) => pathToUrl(e)).toList();
  }
}
