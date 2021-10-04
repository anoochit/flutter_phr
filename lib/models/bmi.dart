import 'package:hive/hive.dart';

part 'bmi.g.dart';

@HiveType(typeId: 1)
class Bmi extends HiveObject {
  @HiveField(0)
  DateTime dateTime;

  @HiveField(1)
  double height;

  @HiveField(2)
  double weight;

  @HiveField(3)
  double bmi;

  @HiveField(4)
  int type;

  Bmi(this.dateTime, this.height, this.weight, this.bmi, this.type);
}
