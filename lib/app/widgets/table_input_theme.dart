import 'package:flutter/material.dart';

const InputDecorationTheme tableInputTheme = InputDecorationTheme(
  isDense: true,
  contentPadding: EdgeInsets.symmetric(horizontal: 3, vertical: 6),
  border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 1.0)),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
  ),
);
