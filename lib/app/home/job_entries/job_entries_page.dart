import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/job_entries/entry_list_item.dart';
import 'package:time_tracker_flutter_course/app/home/job_entries/entry_page.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/list_items_builder.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({@required this.database, @required this.job});
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, Job job) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(database: database, job: job),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Job>(
        stream: database.jobStream(job.id),
        builder: (context, snapshot) {
          final job = snapshot.data;

          return Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              title: Text(job?.name ?? ''),
              actions: <Widget>[
                IconButton(
                  onPressed: () => EntryPage.show(
                    context: context,
                    database: database,
                    job: job,
                  ),
                  icon: Icon(Icons.add),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => EditJobPage.show(
                    context,
                    job: job,
                    database: database,
                  ),
                ),
              ],
            ),
            body: StreamBuilder<List<Entry>>(
              stream: database.entriesStream(job: job),
              builder: (context, snapshot) {
                return ListItemsBuilder<Entry>(
                  snapshot: snapshot,
                  itemBuilder: (context, entry) {
                    return DismissibleEntryListItem(
                      key: Key('entry-${entry.id}'),
                      entry: entry,
                      job: job,
                      onDismissed: () => _deleteEntry(context, entry),
                      onTap: () => EntryPage.show(
                        context: context,
                        database: database,
                        job: job,
                        entry: entry,
                      ),
                    );
                  },
                );
              },
            ),
          );
        });
  }
}
