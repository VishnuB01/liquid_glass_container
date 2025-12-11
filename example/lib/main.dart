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
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: Scaffold(
        body: Stack(
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..scale(-1.0, -1.0),
              child: Image.asset(
                // 'https://images.unsplash.com/photo-1644770510895-b61702eaafc3?q=80&w=3029&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                // 'https://images.unsplash.com/photo-1507608443039-bfde4fbcd142?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                // 'https://images.unsplash.com/photo-1600259487171-f3ec1ee9116a?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                'assets/bgimage/bg_image4.png',
                fit: BoxFit.fill,
                height: double.infinity,
                width: double.infinity,
                colorBlendMode: BlendMode.difference,
              ),
            ),
            SafeArea(
              child: Center(
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 15,
                    children: [
                      SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
                      buildLiquidGlassContainer(
                        width: MediaQuery.sizeOf(context).width * 0.6,
                        context,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.wifi_rounded,
                              color: Colors.white,
                              size: Theme.of(
                                context,
                              ).textTheme.headlineLarge?.fontSize,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Wi-Fi',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  'On',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        blurRadiusPx: 0,
                      ),
                      buildLiquidGlassContainer(
                        width: MediaQuery.sizeOf(context).width * 0.6,
                        context,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.signal_cellular_alt_rounded,
                              color: Colors.white,
                              size: Theme.of(
                                context,
                              ).textTheme.headlineLarge?.fontSize,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Data',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  'On',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        blurRadiusPx: 0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildLiquidGlassContainer(
                            context,
                            Icon(
                              Icons.flight_rounded,
                              color: Colors.orangeAccent,
                              size: Theme.of(
                                context,
                              ).textTheme.headlineMedium?.fontSize,
                            ),
                            bgColor: Colors.greenAccent,
                            lightStrength: 2,
                            blurRadiusPx: 20,
                            borderRadius: 100,
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
                            blurRadiusPx: 9999,
                            lightStrength: 2,
                            borderRadius: 100,
                          ),
                          buildLiquidGlassContainer(
                            context,
                            Icon(
                              Icons.near_me_outlined,
                              color: Colors.tealAccent,
                              size: Theme.of(
                                context,
                              ).textTheme.headlineMedium?.fontSize,
                            ),
                            bgColor: Colors.tealAccent,
                            lightStrength: 2,
                            blurRadiusPx: 20,
                            borderRadius: 100,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
    double? borderRadius = 20,
  }) {
    return LiquidGlassContainer(
      width: width,
      borderRadius: borderRadius ?? 20,
      settings: LiquidGlassSettings(
        blendPx: 20,
        refractStrength: -0.06,
        specAngle: 0.8,
        blurRadiusPx: blurRadiusPx,
        specWidth: 2,
        lightbandColor: bgColor ?? Colors.white,
        lightbandStrength: lightStrength,
      ),
      child: Padding(padding: const EdgeInsets.all(12.0), child: child),
    );
  }
}
