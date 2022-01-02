import 'package:meta/meta.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/services/api_path.dart';
import 'package:time_tracker_flutter_course/services/firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobsStream();
}

class FirestoreDatabase implements Database {
  final String uid;
  final FirestoreService _service = FirestoreService.instance;

  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  Future<void> createJob(Job job) =>
      _service.setData(path: ApiPath.job(uid, 'job_abc'), data: job.toMap());

  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: ApiPath.jobs(uid),
        builder: (data) => Job.fromMap(data),
      );
}
