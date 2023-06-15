import 'dart:math';

List key = [
  'Bearer live_b6ed17c86e7338ffc15c18b482db49',
  'Bearer live_ef3cc35706939c56bccb5ab99117d0',
  'Bearer live_fa9e07a76d1f604adc156927449d54',
  'Bearer live_8450739354f3822e1db42df96806b1',
  'Bearer live_b8af81619c2465683b1395abe5568b',
  'Bearer live_9325cd719264d004cc8886c372c77c',
  'Bearer live_6e24d6e66a3637f82706403c4e8e79',
  'Bearer live_55c75ee427fb091946f2cf6bdfa864',
  'Bearer live_4792695cebb17de4ed09a689ce8ee0',
  'Bearer live_d2abfb099c058a1705cc4713b5c781',
  'Bearer live_f58ccede50417290f84d76fb71d98d',
  'Bearer live_136d6e8c7c369320a95dcd4f04beb6'
];

String auths() {
  int position = Random().nextInt(key.length);
  return key[position];
}
