import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final inputPath = 'assets/icons/logo.png';
  final androidPath = 'assets/icons/logo_padded.png';
  final iosPath = 'assets/icons/logo_ios.png';
  
  final imageBytes = File(inputPath).readAsBytesSync();
  final originalImage = img.decodeImage(imageBytes);
  if (originalImage == null) return;
  
  // Resize to 768x768 (66% of 1152) to give 17% padding on all sides
  final resized = img.copyResize(originalImage, width: 768, height: 768, interpolation: img.Interpolation.average);
  
  // 1. Android Transparent Padding
  final padded = img.Image(width: 1152, height: 1152, numChannels: 4);
  img.compositeImage(padded, resized, dstX: (1152 - 768) ~/ 2, dstY: (1152 - 768) ~/ 2);
  File(androidPath).writeAsBytesSync(img.encodePng(padded));
  print('Saved $androidPath');

  // 2. iOS Solid Background (#F7F3EB = 247, 243, 235)
  final iosBg = img.Image(width: 1152, height: 1152, numChannels: 4);
  // fill with F7F3EB
  img.fill(iosBg, color: img.ColorRgba8(247, 243, 235, 255));
  img.compositeImage(iosBg, resized, dstX: (1152 - 768) ~/ 2, dstY: (1152 - 768) ~/ 2);
  File(iosPath).writeAsBytesSync(img.encodePng(iosBg));
  print('Saved $iosPath');
}
