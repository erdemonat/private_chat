import 'package:isar/isar.dart';

part 'theme_settings.g.dart';

@Collection()
class ThemeSettings {
  Id id = Isar.autoIncrement;

  late String themeName;
}
