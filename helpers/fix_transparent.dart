import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final path = 'assets/icons/transparent.png';
  final image = img.Image(width: 256, height: 256, numChannels: 4);
  File(path).writeAsBytesSync(img.encodePng(image));
  print('Saved $path');
}
