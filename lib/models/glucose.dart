import 'package:hive/hive.dart';

part 'glucose.g.dart';

// 0 = fasting, 1 = After Eating, 2 = 2-3 After Eating
@HiveType(typeId: 2)
class Glucose extends HiveObject {
  @HiveField(0)
  DateTime dateTime;

  @HiveField(1)
  int unit;

  @HiveField(2)
  List<String> tag;

  @HiveField(3)
  int when;

  @HiveField(4)
  int level;

  Glucose(this.dateTime, this.unit, this.tag, this.when, this.level);
}
