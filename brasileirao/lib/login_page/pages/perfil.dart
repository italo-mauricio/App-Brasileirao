import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


TextStyle _FontHeader = GoogleFonts.openSans(
  fontSize: 30,
  fontWeight: FontWeight.bold,
  fontStyle: FontStyle.normal,
  color: Colors.black,
);

TextStyle _FontNormalText = GoogleFonts.openSans(
  fontSize: 20,
  fontWeight: FontWeight.normal,
  fontStyle: FontStyle.normal,
  color: Colors.black,
);

Widget meu_perfil() {
  return SingleChildScrollView(
    child: Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text(
            "Nome: Italo Mauricio\n Curso: Sistemas de Informação\n Universidade Federal Do Rio Grande do Norte\n Disciplina: Programação Orientada a Objetos\n Professor: Fabrício Vale",
            style: _FontHeader,
            textAlign: TextAlign.center,
          ),  
        ],
      ),
    ),
  );
}