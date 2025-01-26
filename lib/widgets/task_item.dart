import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
  });

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool isDone = false;

  void handleCheckboxChange(bool? value) {
    setState(() {
      isDone = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDone ? Color.fromARGB(151, 255, 255, 255) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000).withAlpha(10),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Checkbox(
              value: isDone,
              onChanged: handleCheckboxChange,
              shape: CircleBorder(),
              checkColor: Colors.white,
              activeColor: Colors.green,
            ),
            Text(
              'Task name',
              style: TextStyle(
                color: Color(0xFF333333),
              ),
            ),
            Spacer(),
            if (!isDone)
              IconButton(
                onPressed: () {},
                icon: FaIcon(FontAwesomeIcons.play),
                color: Theme.of(context).primaryColor,
                iconSize: 16,
              ),
          ],
        ),
      ),
    );
  }
}
