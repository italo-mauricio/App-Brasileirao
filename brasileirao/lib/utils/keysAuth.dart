import 'dart:math';

List key = [
  'Bearer live_136d6e8c7c369320a95dcd4f04beb6',
  // 'Bearer live_4792695cebb17de4ed09a689ce8ee0'
];

String auths() {
  int position = Random().nextInt(key.length);
  return key[position];
}
