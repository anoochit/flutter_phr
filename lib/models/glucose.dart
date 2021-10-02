import 'package:hive/hive.dart';

part 'glucose.g.dart';

@HiveType(typeId: 2)
class Glucose extends HiveObject {
  @HiveField(0)
  DateTime dateTime;

  @HiveField(1)
  int unit;

  @HiveField(2)
  List<String> tag;

  Glucose(this.dateTime, this.unit, this.tag);
}
