import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/todo_login_response.dart';

class TodoItem extends StatelessWidget {
  final Todos todo;
  const TodoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 12.h),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r), color: Colors.grey[400]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(todo.id.toString()),
          SizedBox(
            height: 8.h,
          ),
          todo.completed.runtimeType == bool
              ? Text(todo.completed.toString())
              : todo.completed == 1
                  ? const Text("true")
                  : const Text("false"),
          SizedBox(
            height: 8.h,
          ),
          Text(todo.todo ?? ""),
        ],
      ),
    );
  }
}
