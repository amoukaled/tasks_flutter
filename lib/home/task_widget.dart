// Flutter imports
import 'package:flutter/material.dart';

// Pub imports
import 'package:provider/provider.dart';

// App imports
import 'package:tasks_flutter/models/task.dart';
import 'package:tasks_flutter/provider/task_state.dart';
import 'package:tasks_flutter/shared/AnimatedCustomCheckbox.dart';

class TaskWidget extends StatefulWidget {
  final Task task;
  final int index;

  TaskWidget({
    required this.task,
    required Key key,
    required this.index,
  }) : super(key: key);

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  final _shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10),
      topRight: Radius.circular(10),
    ),
  );
  final Duration _duration = Duration(milliseconds: 200);
  final double _radius = 8.0;

  late TextEditingController _titleCont;
  late TextEditingController _noteCont;
  late FocusNode _noteFocus;

  @override
  void initState() {
    super.initState();
    _titleCont = TextEditingController(text: widget.task.title);
    _noteCont = TextEditingController(text: widget.task.note);
    _noteFocus = FocusNode();
  }

  @override
  void dispose() {
    _titleCont.dispose();
    _noteCont.dispose();
    _noteFocus.dispose();
    super.dispose();
  }

  bool get isInputValid => (_titleCont.text.isNotEmpty);

  void _cancelSheet(BuildContext context) {
    _titleCont.text = widget.task.title;
    _noteCont.text = widget.task.note;
    Navigator.pop(context);
  }

  Future<void> _submitSheet(BuildContext context) async {
    if (isInputValid) {
      widget.task.title = _titleCont.text;
      widget.task.note = _noteCont.text;

      await Provider.of<TaskState>(context, listen: false)
          .updateTask(widget.task);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      shadowColor: Colors.transparent,
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
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
                                      "Edit Task",
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
                                          Icons.save,
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
                                          "Save",
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
        },
        child: AnimatedContainer(
          duration: _duration,
          width: MediaQuery.of(context).size.width - 10,
          // height: ((MediaQuery.of(context).size.width - 10) / 2),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (!widget.task.isChecked)
                ? Colors.blueGrey[300]
                : Colors.grey[500],
            borderRadius: BorderRadius.all(Radius.circular(_radius)),
          ),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            children: [
              AnimatedCustomCheckbox(
                background: Colors.grey[600]!,
                height: 20,
                width: 20,
                onChanged: (bool val) {
                  Provider.of<TaskState>(context, listen: false)
                      .toggleTask(widget.index, val);
                },
                value: widget.task.isChecked,
                borderColor: Colors.teal[800]!,
                // background: Colors.teal[800]!,
              ),
              SizedBox(width: 10),
              Expanded(
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: AnimatedDefaultTextStyle(
                    duration: _duration,
                    style: (widget.task.isChecked)
                        ? TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            decoration: TextDecoration.lineThrough,
                          )
                        : TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    child: Text(
                      widget.task.title,
                    ),
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.delete, color: Colors.red[900]),
                onPressed: () async =>
                    await Provider.of<TaskState>(context, listen: false)
                        .removeTask(widget.index),
              ),
              ReorderableDragStartListener(
                index: widget.index,
                key: Key(widget.task.id),
                child: Icon(
                  Icons.menu,
                  color: Colors.grey[900],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
