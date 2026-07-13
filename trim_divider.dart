import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final inputPath = 'assets/images/divider.png';
  final outputPath = 'assets/images/divider_trimmed.png';
  
  final imageBytes = File(inputPath).readAsBytesSync();
  final originalImage = img.decodeImage(imageBytes);
  if (originalImage == null) return;
  
  int minX = originalImage.width;
  int minY = originalImage.height;
  int maxX = 0;
  int maxY = 0;

  for (int y = 0; y < originalImage.height; y++) {
    for (int x = 0; x < originalImage.width; x++) {
      final pixel = originalImage.getPixel(x, y);
      if (pixel.a > 0) { // If pixel is not fully transparent
        if (x < minX) minX = x;
        if (x > maxX) maxX = x;
        if (y < minY) minY = y;
        if (y > maxY) maxY = y;
      }
    }
  }

  // If the image is entirely transparent, skip
  if (minX > maxX || minY > maxY) {
    print('Image is completely transparent.');
    return;
  }

  final croppedWidth = maxX - minX + 1;
  final croppedHeight = maxY - minY + 1;

  final croppedImage = img.copyCrop(
    originalImage,
    x: minX,
    y: minY,
    width: croppedWidth,
    height: croppedHeight,
  );

  File(outputPath).writeAsBytesSync(img.encodePng(croppedImage));
  print('Saved \$outputPath (Width: \$croppedWidth, Height: \$croppedHeight)');
}
