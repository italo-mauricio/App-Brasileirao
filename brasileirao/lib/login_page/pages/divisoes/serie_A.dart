import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


TextStyle _FontHeader = const TextStyle(
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
    fontSize: 30,
    color: Colors.black);

TextStyle _FontNormalText = GoogleFonts.openSans(
  fontSize: 20,
  fontWeight: FontWeight.normal,
  fontStyle: FontStyle.normal,
  color: Colors.black,
);

Widget tabela_seria_A() {
  return SingleChildScrollView(
    child: Container(
    padding: const EdgeInsets.all(
        16.0), // Adiciona um padding de 16.0 em todas as direções
    child: Column(
      children: <Widget>[
        FadeInImage(
          placeholder:
              NetworkImage('https://pbs.twimg.com/media/Fs0BPfGWwAI39Pi.png'),
         // image: imageBarcaLogo,
          height: 300, // Altura da imagem em pixels
        ),
        const SizedBox(height: 16.0),
        Text(
          'Em 1899, Joan Gamper, um suíço, decidiu introduzir o futebol em Barcelona, montando um time. O clube foi oficialmente fundado no dia 29 de novembro de 1899.',
          style: _FontNormalText,
        ),
      ],
    ),
  ),
  );
}