import 'dart:ui';

import 'package:meta/meta.dart';

class Job {
  final String id;
  final String name;
  final int ratePerHour;

  const Job(
      {@required this.id, @required this.name, @required this.ratePerHour});

  factory Job.fromMap(Map<String, dynamic> map, String id) {
    if (map == null) return null;

    final name = map['name'] as String;
    if (name == null) return null;

    return Job(
      id: id,
      name: name,
      ratePerHour: (map['ratePerHour'] as num).toInt(),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'ratePerHour': ratePerHour,
      };

  @override
  int get hashCode => hashValues(id, name, ratePerHour);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Job otherJob = other;
    return id == otherJob.id &&
        name == otherJob.name &&
        ratePerHour == otherJob.ratePerHour;
  }

  @override
  String toString() => 'id: $id, name: $name, ratePerHour: $ratePerHour';
}
