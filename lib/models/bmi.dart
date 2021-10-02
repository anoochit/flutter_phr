import 'package:hive/hive.dart';

part 'bmi.g.dart';

@HiveType(typeId: 1)
class Bmi extends HiveObject {
  @HiveField(0)
  DateTime dateTime;

  @HiveField(1)
  int height;

  @HiveField(2)
  int weight;

  @HiveField(3)
  double bmi;

  Bmi(this.dateTime, this.height, this.weight, this.bmi);
}
