import 'package:flutter/material.dart';

class AnimatedCustomCheckbox extends StatelessWidget {
  final bool value;
  final double width;
  final double height;
  final void Function(bool) onChanged;
  final Duration? duration;
  final Color background;
  final Color foreground;
  final Color borderColor;

  AnimatedCustomCheckbox({
    required this.height,
    required this.width,
    required this.onChanged,
    required this.value,
    this.duration,
    this.background = Colors.grey,
    this.foreground = Colors.white,
    this.borderColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shadowColor: Colors.transparent,
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onChanged(!value);
        },
        child: AnimatedContainer(
          duration: duration ?? Duration(milliseconds: 100),
          margin: EdgeInsets.all(4),
          height: (!value) ? height : (height * 0.9),
          width: (!value) ? width : (width * 0.9),
          decoration: BoxDecoration(
            color: (!value) ? Colors.transparent : background,
            border:
                Border.all(width: 2, color: !value ? borderColor : background),
            borderRadius: BorderRadius.circular(4),
          ),
          child: (value)
              ? Padding(
                  padding: EdgeInsets.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.close_rounded,
                        size: height * 0.7,
                        color: foreground,
                      ),
                    ],
                  ))
              : null,
        ),
      ),
    );
  }
}
