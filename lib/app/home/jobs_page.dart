import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        actions: [
          TextButton(
            onPressed: () => _confirmSignOut(context),
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ),
        ],
      ),
      body: _Jobs(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createJob(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure you want to logout?',
      defaultActionText: 'Logout',
      cancelActionText: 'Cancel',
    );

    if (didRequestSignOut) {
      _signOut(context);
    }
  }

  void _signOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);

    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _createJob(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.createJob(Job(name: 'Blogging', ratePerHour: 10));
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }
}

class _Jobs extends StatelessWidget {
  const _Jobs({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: snapshot.data.map((e) => Text(e.name)).toList(),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Some error ocurred'));
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
