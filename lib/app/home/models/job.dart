import 'package:meta/meta.dart';

class Job {
  final String name;
  final int ratePerHour;

  const Job({@required this.name, @required this.ratePerHour});

  factory Job.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Job(
      name: map['name'] as String,
      ratePerHour: (map['ratePerHour'] as num).toInt(),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'ratePerHour': ratePerHour,
      };
}
