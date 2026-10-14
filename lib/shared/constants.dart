import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  filled: true,
  fillColor: Color(0xFFFFFCF7),
  contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 17),
  hintStyle: TextStyle(color: Color(0xFF8B8177)),
  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide.none),
  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide(color: Color(0xFFE8DED2))),
  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide(color: Color(0xFFE8753D), width: 1.5)),
);
