import 'dart:math';

List key = [
  'Bearer live_b6ed17c86e7338ffc15c18b482db49',
  'Bearer live_ef3cc35706939c56bccb5ab99117d0',
  'Bearer live_fa9e07a76d1f604adc156927449d54',
  'Bearer live_8450739354f3822e1db42df96806b1',
  'Bearer live_b8af81619c2465683b1395abe5568b'
];

String auths() {
  int position = Random().nextInt(key.length);
  return key[position];
}
