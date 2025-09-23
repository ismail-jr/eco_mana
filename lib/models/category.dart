import 'package:hive/hive.dart';

part 'category.g.dart'; // generated file

@HiveType(typeId: 1)
class Category extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String icon; // optional: emoji or icon string

  Category({required this.id, required this.name, this.icon = ''});
}
