import 'package:hive/hive.dart';

class Guest {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String address;

  @HiveField(2)
  final DateTime arrivalDate;

  Guest({
    this.name,
    this.address,
    this.arrivalDate,
  });

  Guest.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        address = json['address'],
        arrivalDate = DateTime.fromMillisecondsSinceEpoch(json['arrival_date']);

  Map<String, dynamic> toMap() => {
        'name': name,
        'address': address,
        'arrival_date': arrivalDate.millisecondsSinceEpoch,
      };
}

class GuestAdapter extends TypeAdapter<Guest> {
  @override
  Guest read(BinaryReader reader) {
    final map = <int, dynamic>{
      0: reader.read(),
      1: reader.read(),
      2: reader.read(),
    };

    return Guest(
      name: map[0],
      address: map[1],
      arrivalDate: map[2],
    );
  }

  @override
  final typeId = 0;

  @override
  void write(BinaryWriter writer, Guest obj) {
    writer..write(obj.name)..write(obj.address)..write(obj.arrivalDate);
  }
}
