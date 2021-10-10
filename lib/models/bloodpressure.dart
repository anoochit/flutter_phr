import 'package:hive/hive.dart';

part 'bloodpressure.g.dart';

@HiveType(typeId: 0)
class BloodPressure extends HiveObject {
  @HiveField(0)
  DateTime dateTime;

  @HiveField(1)
  int systolic;

  @HiveField(2)
  int diastolic;

  @HiveField(3)
  int pulse;

  @HiveField(4)
  int type;

  @HiveField(5)
  List<String> tag;

  BloodPressure(this.dateTime, this.systolic, this.diastolic, this.pulse,
      this.type, this.tag);
}
