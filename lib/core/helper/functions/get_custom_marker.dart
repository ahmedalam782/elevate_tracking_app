import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> getCustomMarker({
  required String assetPath,
  int width = 100,
}) async {
  final ByteData data = await rootBundle.load(assetPath);
  final Uint8List bytes = data.buffer.asUint8List();

  final ui.Codec codec = await ui.instantiateImageCodec(
    bytes,
    targetWidth: width,
  );

  final ui.FrameInfo frameInfo = await codec.getNextFrame();
  final ui.Image image = frameInfo.image;

  final ByteData? resizedData = await image.toByteData(
    format: ui.ImageByteFormat.png,
  );

  return BitmapDescriptor.fromBytes(resizedData!.buffer.asUint8List());
}
