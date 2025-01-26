import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pomodoro/widgets/custom_appbar.dart';
import 'package:pomodoro/widgets/task_item.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  TaskListState createState() => TaskListState();
}

class TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My tasks',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: FaIcon(FontAwesomeIcons.plus),
                    color: Color(0xFF333333),
                  ),
                ],
              ),
              SizedBox(height: 14),
              Column(
                spacing: 14,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today',
                    style: TextStyle(
                      color: Color.fromARGB(225, 95, 95, 95),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TaskItem(),
                  TaskItem(),
                  TaskItem(),
                  Text(
                    'Yesterday',
                    style: TextStyle(
                      color: Color.fromARGB(225, 95, 95, 95),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TaskItem(),
                  TaskItem(),
                  TaskItem(),
                  Text(
                    'Last week',
                    style: TextStyle(
                      color: Color.fromARGB(225, 95, 95, 95),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TaskItem(),
                  TaskItem(),
                  TaskItem(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
