import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();

  Future<void> setData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final documentReference = FirebaseFirestore.instance.doc(path);

    await documentReference.set(data);
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);

    return reference.snapshots().map(
          (snapshot) => snapshot.docs.map((d) => builder(d.data())).toList(),
        );
  }
}
