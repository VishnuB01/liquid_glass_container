import 'package:flutter/material.dart';
import 'package:liquid_glass_container/liquid_glass_container.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Image.network(
                // 'https://images.unsplash.com/photo-1644770510895-b61702eaafc3?q=80&w=3029&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                // 'https://images.unsplash.com/photo-1507608443039-bfde4fbcd142?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'https://images.unsplash.com/photo-1600259487171-f3ec1ee9116a?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                fit: BoxFit.fill,
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 10,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      buildLiquidGlassContainer(
                        width: MediaQuery.sizeOf(context).width * 0.7,
                        context,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          spacing: 10,
                          children: [
                            Icon(
                              Icons.wifi_rounded,
                              color: Colors.white,
                              size: Theme.of(
                                context,
                              ).textTheme.headlineMedium?.fontSize,
                            ),
                            Text(
                              'Connected',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        blurRadiusPx: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildLiquidGlassContainer(
                            context,
                            Icon(
                              Icons.flight_rounded,
                              color: Colors.greenAccent,
                              size: Theme.of(
                                context,
                              ).textTheme.headlineMedium?.fontSize,
                            ),
                            bgColor: Colors.greenAccent,
                            lightStrength: 2,
                            blurRadiusPx: 8,
                          ),
                          buildLiquidGlassContainer(
                            context,
                            Icon(
                              Icons.bluetooth_rounded,
                              color: Colors.white,
                              size: Theme.of(
                                context,
                              ).textTheme.headlineMedium?.fontSize,
                            ),
                            bgColor: Colors.white,
                            lightStrength: 2,
                          ),
                          buildLiquidGlassContainer(
                            context,
                            Icon(
                              Icons.bluetooth_rounded,
                              color: Colors.blueAccent,
                              size: Theme.of(
                                context,
                              ).textTheme.headlineMedium?.fontSize,
                            ),
                            bgColor: Colors.blueAccent,
                            lightStrength: 2,
                            blurRadiusPx: 8,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LiquidGlassContainer buildLiquidGlassContainer(
    BuildContext context,
    Widget child, {
    Color? bgColor = Colors.white,
    double lightStrength = 0.9,
    double blurRadiusPx = 0.9,
    double? width,
  }) {
    return LiquidGlassContainer(
      width: width,
      borderRadius: 20,
      settings: LiquidGlassSettings(
        blurRadiusPx: blurRadiusPx,
        specWidth: 2,
        lightbandColor: bgColor ?? Colors.white,
        lightbandStrength: lightStrength,
      ),
      child: Padding(padding: const EdgeInsets.all(12.0), child: child),
    );
  }
}
