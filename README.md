# liquid_glass_container

A customizable radar (spider) chart widget for Flutter.  
This package helps you visualize multi-dimensional data in a clean, interactive radar chart.

---
<img src="https://raw.githubusercontent.com/VishnuB01/radar_chart_plus/main/example/lib/assets/chart_image.jpg" width="400" alt="Radar Chart Example">

## Features

- 💧 Apple-style liquid glass effect

- 🌫️ Realistic refraction, blur, and distortion

- 📱 Fully responsive and GPU-accelerated using shaders

- ⚡ Lightweight, smooth performance

---

## Getting started

### Add the dependency:

```yaml
dependencies:
  liquid_glass_container: <latest_version>
```
### Import it:

```dart
import 'package:liquid_glass_container/liquid_glass_container.dart';
```

### Usage
```dart
LiquidGlassContainer(
  width: 250,
  height: 250,
  borderRadius: BorderRadius.circular(30),
  backgroundColor: Colors.white,
  child: Center(
    child: Text(
      "Liquid Glass",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  ),
);
```
---

## Additional information

**liquid_glass_container** aims to replicate the premium liquid glass effect widely seen in modern Apple UI.
This widget is built with Flutter’s shader support and offers high customizability while staying lightweight.

**Use it for:**

* Cards
* Dialogs
* Profile sections
* Modern dashboard components
* Decorative UI blocks

If you need enhancements — feel free to open an issue or request on GitHub!

## Contribution

Contributions are highly appreciated! Want to add improvements or fix something?

**Follow these steps:**

1. Fork the repository
2. Create a branch for your feature or bug fix
3. Implement your changes with clean commit messages
4. Submit a Pull Request describing what you changed and why
5. Your PR will be reviewed and merged after approval