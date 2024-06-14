import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:privatechat/local_data/theme_settings.dart';

class IsarService {
  static final IsarService _instance = IsarService._internal();
  Isar? _isar;

  factory IsarService() {
    return _instance;
  }

  IsarService._internal();

  Future<Isar> get db async {
    if (_isar == null) {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        [ThemeSettingsSchema],
        directory: dir.path,
      );
    }
    return _isar!;
  }
}
