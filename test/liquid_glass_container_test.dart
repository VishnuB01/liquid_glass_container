import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_container_plus/liquid_glass_container_plus.dart';

void main() {
  test('Liquid Glass Container Created', () {
    LiquidGlassContainer(
      width: 150,
      height: 100,
      child: Center(child: Text('Liquid Glass Container')),
    );
  });
}
