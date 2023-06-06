import 'dart:math';

List key = [
  'Chave 0',
  'Chave 1',
  'Chave 2',
  'Chave 3',
  'Chave 4'
];

String auths() {
  int position = Random().nextInt(key.length);
  return key[position];
}
