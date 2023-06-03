import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Fontes {
  TextStyle FontHeader() {
    return GoogleFonts.openSans(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      color: Colors.black,
    );
  }

  TextStyle FontNormalText() {
    return GoogleFonts.openSans(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      color: Colors.black,
    );
  }
}
