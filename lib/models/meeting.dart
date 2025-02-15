import 'package:flutter/material.dart';

class Meeting {
  final String title;
  final String time;
  final Color bgColor;
  final Color lineColor;

  Meeting({
    required this.title,
    required this.time,
    required this.bgColor,
    required this.lineColor,
  });
}
