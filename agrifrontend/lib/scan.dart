import 'package:hive/hive.dart';

part "scan.g.dart";

@HiveType(typeId: 0)
class Scan extends HiveObject {
  @HiveField(0)
  String plantName;

  @HiveField(1)
  String commonName;

  @HiveField(2)
  String disease;

  @HiveField(3)
  String date;

  Scan({
    required this.plantName,
    required this.commonName,
    required this.disease,
    required this.date,
  });
}
