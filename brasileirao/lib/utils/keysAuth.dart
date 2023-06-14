import 'dart:math';

List key = [
  'Bearer live_55c75ee427fb091946f2cf6bdfa864',
  'Bearer live_4792695cebb17de4ed09a689ce8ee0'
];

String auths() {
  int position = Random().nextInt(key.length);
  return key[position];
}
