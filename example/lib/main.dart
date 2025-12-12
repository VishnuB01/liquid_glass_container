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
              transform: Matrix4.diagonal3Values(-1, -1, 1),
              child: Image.asset(
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
                              color: Colors.white70,
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
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  'Off',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        blurRadiusPx: 5,
                      ),
                      buildRoundIconsRow(context),
                      LiquidGlassContainer(
                        settings: LiquidGlassSettings(blurRadiusPx: 100),
                        borderRadius: 20,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            spacing: 10,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(),
                              Expanded(
                                child: LinearProgressIndicator(
                                  borderRadius: BorderRadius.circular(20),
                                  value: 0.7,
                                  color: Colors.white,
                                  backgroundColor: Colors.grey,
                                ),
                              ),
                              Icon(
                                Icons.volume_up_rounded,
                                color: Colors.white,
                                size: Theme.of(
                                  context,
                                ).textTheme.headlineMedium?.fontSize,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          liquidVerticalSlider(
                            context,
                            Icons.wb_sunny_rounded,
                            0.5,
                            Colors.orangeAccent,
                          ),
                          liquidVerticalSlider(
                            context,
                            Icons.volume_up_rounded,
                            0.3,
                            Colors.blueAccent,
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

  LiquidGlassContainer liquidVerticalSlider(
    BuildContext context,
    IconData icon,
    double value,
    Color iconColor,
  ) {
    return LiquidGlassContainer(
      borderRadius: 40,
      child: Container(
        height: 150,
        width: 70,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.transparent,
              Colors.white,
              Colors.white,
            ],
            stops: [0.0, value, value, 1.0],
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Icon(
              icon,
              color: iconColor,
              size: Theme.of(context).textTheme.headlineMedium?.fontSize,
            ),
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

  Row buildRoundIconsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildLiquidGlassContainer(
          context,
          Icon(
            Icons.flight_rounded,
            color: Colors.orangeAccent,
            size: Theme.of(context).textTheme.headlineMedium?.fontSize,
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
            size: Theme.of(context).textTheme.headlineMedium?.fontSize,
          ),
          bgColor: Colors.blueAccent,
          blurRadiusPx: 9999,
          lightStrength: 2,
          borderRadius: 100,
        ),
        buildLiquidGlassContainer(
          context,
          Icon(
            Icons.wifi_tethering,
            color: Colors.tealAccent,
            size: Theme.of(context).textTheme.headlineMedium?.fontSize,
          ),
          bgColor: Colors.tealAccent,
          lightStrength: 2,
          blurRadiusPx: 20,
          borderRadius: 100,
        ),
      ],
    );
  }
}
