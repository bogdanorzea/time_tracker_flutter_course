import 'package:meta/meta.dart';

class Job {
  final String id;
  final String name;
  final int ratePerHour;

  const Job({@required this.id, @required this.name, @required this.ratePerHour});

  factory Job.fromMap(Map<String, dynamic> map, String id) {
    if (map == null) return null;

    return Job(
      id: id,
      name: map['name'] as String,
      ratePerHour: (map['ratePerHour'] as num).toInt(),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'ratePerHour': ratePerHour,
      };
}
