import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 3)
class Settings extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String photo;

  Settings(this.name, this.photo);
}
