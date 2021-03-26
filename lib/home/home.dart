// Flutter imports
import 'package:flutter/material.dart';

// Pub imports
import 'package:provider/provider.dart';

// App imports
import 'package:tasks_flutter/home/home_header.dart';
import 'package:tasks_flutter/home/new_task_widget.dart';
import 'package:tasks_flutter/home/task_widget.dart';
import 'package:tasks_flutter/models/task.dart';
import 'package:tasks_flutter/provider/task_state.dart';

class Home extends StatelessWidget {
  Widget _getTodo(Task task, int index) => TaskWidget(
        index: index,
        task: task,
        key: Key(task.id),
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: [
            SliverToBoxAdapter(
              child: HomeHeader(),
            ),
            Consumer<TaskState>(builder: (context, TaskState state, _) {
              return SliverReorderableList(
                itemBuilder: (context, index) {
                  return _getTodo(state.tasks[index], index);
                },
                itemCount: state.tasks.length,
                onReorder: (int oldIndex, int newIndex) {
                  state.reorderItems(oldIndex, newIndex);
                },
              );
            }),
            SliverToBoxAdapter(
                child: SizedBox(
              height: 100,
            )),
          ],
        ),
        floatingActionButton: NewTaskWidget(),
      ),
    );
  }
}
