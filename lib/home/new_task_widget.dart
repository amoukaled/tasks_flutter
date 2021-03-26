// Flutter imports
import 'package:flutter/material.dart';

// Pub imports
import 'package:provider/provider.dart';

// App imports
import 'package:tasks_flutter/models/task.dart';
import 'package:tasks_flutter/provider/task_state.dart';

class NewTaskWidget extends StatefulWidget {
  @override
  _NewTaskWidgetState createState() => _NewTaskWidgetState();
}

class _NewTaskWidgetState extends State<NewTaskWidget> {
  final _shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10),
      topRight: Radius.circular(10),
    ),
  );

  late TextEditingController _titleCont;
  late TextEditingController _noteCont;
  late FocusNode _noteFocus;

  @override
  void initState() {
    super.initState();
    _titleCont = TextEditingController();
    _noteCont = TextEditingController();
    _noteFocus = FocusNode();
  }

  @override
  void dispose() {
    _titleCont.dispose();
    _noteCont.dispose();
    _noteFocus.dispose();
    super.dispose();
  }

  void _cancelSheet(BuildContext context) {
    _titleCont.clear();
    _noteCont.clear();
    Navigator.pop(context);
  }

  Future<void> _submitSheet(BuildContext context) async {
    if (isInputValid) {
      String title = _titleCont.text;
      String note = _noteCont.text;
      int position =
          Provider.of<TaskState>(context, listen: false).tasks.length;

      Task task = Task(note: note, title: title, position: position);
      await Provider.of<TaskState>(context, listen: false).addTask(task);
      _cancelSheet(context);
    }
  }

  bool get isInputValid => (_titleCont.text.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 0,
        onPressed: () async {
          await showModalBottomSheet(
            enableDrag: false,
            shape: _shape,
            backgroundColor: Colors.grey[400],
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setSheetState) {
                  return WillPopScope(
                    onWillPop: () async {
                      _cancelSheet(context);
                      return true;
                    },
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).accentColor,
                                        borderRadius: _shape.borderRadius),
                                    child: Text(
                                      "New Task",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Card(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              shape: CardTheme.of(context).shape,
                              color: CardTheme.of(context).color,
                              elevation: CardTheme.of(context).elevation,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Title:",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: TextField(
                                      autofocus: true,
                                      onChanged: (_) {
                                        setSheetState(() {});
                                      },
                                      onEditingComplete: () {
                                        if (!_noteFocus.hasFocus) {
                                          _noteFocus.requestFocus();
                                        }
                                      },
                                      controller: _titleCont,
                                      maxLines: 1,
                                      keyboardType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      textAlign: TextAlign.start,
                                      decoration: InputDecoration(
                                        counterText: '',
                                        hintText: 'Title',
                                        hintStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w300,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        border: InputBorder.none,
                                        fillColor: Colors.transparent,
                                        filled: true,
                                      ),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Card(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              shape: CardTheme.of(context).shape,
                              color: CardTheme.of(context).color,
                              elevation: CardTheme.of(context).elevation,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Note:",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: TextField(
                                      autofocus: true,
                                      onEditingComplete: () async =>
                                          await _submitSheet(context),
                                      controller: _noteCont,
                                      focusNode: _noteFocus,
                                      maxLines: 1,
                                      keyboardType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      textAlign: TextAlign.start,
                                      decoration: InputDecoration(
                                        counterText: '',
                                        hintText: 'Note',
                                        hintStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w300,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        border: InputBorder.none,
                                        fillColor: Colors.transparent,
                                        filled: true,
                                      ),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: TextButton.icon(
                                        icon: Icon(
                                          Icons.add,
                                          color: IconTheme.of(context).color,
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                TextButtonTheme.of(context)
                                                    .style!
                                                    .backgroundColor,
                                            shape: TextButtonTheme.of(context)
                                                .style!
                                                .shape),
                                        label: Text(
                                          "Add",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                        onPressed: (isInputValid)
                                            ? () async {
                                                await _submitSheet(
                                                    context); // _cancelSheet(context);
                                              }
                                            : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        });
  }
}
