import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A customizable container widget that applies a liquid-glass (frosted glass)
/// shader effect behind its child.
///
/// This widget behaves like a regular [Container] but renders a real-time
/// shader-based blur and distortion effect when `enabled` is `true`.
///
/// If the shader asset fails to load or the effect is disabled, the widget
/// gracefully falls back to a normal container.
///
/// Example:
/// ```dart
/// LiquidGlassContainer(
///   width: 200,
///   height: 120,
///   borderRadius: 16,
///   color: Colors.white.withOpacity(0.2),
///   child: Text('Hello'),
/// );
/// ```

class LiquidGlassContainer extends StatefulWidget {
  /// The widget placed inside the liquid glass container.
  ///
  /// This behaves the same as the `child` property of a regular [Container].
  /// The width of the container.
  ///
  /// If null, the widget will size itself according to its parent constraints.
  final Widget? child;

  /// The width of the container.
  ///
  /// If null, the widget will size itself according to its parent constraints.
  final double? width;

  /// The height of the container.
  ///
  /// If null, the widget will size itself according to its parent constraints.
  final double? height;

  /// The border radius applied to the container and the shader clipping.
  ///
  /// Defaults to `0.0`.
  final double borderRadius;

  /// The base background color that appears behind the shader effect.
  ///
  /// This can be used to tint the liquid-glass surface.
  /// Defaults to `Colors.transparent`.
  final Color color;
  final BoxShadow? shadow;

  /// Settings that control the behavior of the liquid glass shader.
  ///
  /// Includes blur intensity, refraction strength, distortion falloff, etc.
  final LiquidGlassSettings settings;

  /// Whether the shader effect is enabled.
  ///
  /// When `false`, the widget falls back to a regular container.
  final bool enabled;

  const LiquidGlassContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.borderRadius = 0.0,
    this.color = Colors.transparent,
    this.shadow,
    this.settings = const LiquidGlassSettings(),
    this.enabled = true,
  });

  @override
  State<LiquidGlassContainer> createState() => _LiquidGlassContainerState();
}

class _LiquidGlassContainerState extends State<LiquidGlassContainer> {
  FragmentProgram? _program;

  @override
  void initState() {
    super.initState();
    _loadShader();
  }

  void _loadShader() async {
    try {
      final program = await FragmentProgram.fromAsset(
        'packages/liquid_glass_container_plus/shaders/liquid_glass.frag',
      );
      if (mounted) {
        setState(() => _program = program);
      }
    } catch (e) {
      debugPrint('Failed to load shader: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final shadow = widget.shadow?.copyWith(
      blurStyle: BlurStyle.outer,
      offset: const Offset(0, 0),
    );

    final container = Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: shadow != null ? [shadow] : null,
      ),
      child: widget.child,
    );

    // Return plain container if shader not loaded or effect disabled
    if (_program == null || !widget.enabled) {
      return container;
    }

    // Apply shader effect
    return _LiquidGlassRenderWidget(
      shader: _program!.fragmentShader(),
      settings: widget.settings,
      borderRadius: widget.borderRadius,
      color: widget.color,
      child: container,
    );
  }
}

/// Simplified configuration for the liquid glass effect
class LiquidGlassSettings {
  final double blendPx;
  final double refractStrength;
  final double distortFalloffPx;
  final double distortExponent;
  final double blurRadiusPx;

  final double specAngle;
  final double specStrength;
  final double specPower;
  final double specWidth;

  final double lightbandOffsetPx;
  final double lightbandWidthPx;
  final double lightbandStrength;
  final Color lightbandColor;

  const LiquidGlassSettings({
    this.blendPx = 20,
    this.refractStrength = -0.04,
    this.distortFalloffPx = 35,
    this.distortExponent = 4,
    this.blurRadiusPx = 2.0,

    this.specAngle = 4,
    this.specStrength = 4.0,
    this.specPower = 4,
    this.specWidth = 1.5,

    this.lightbandOffsetPx = 10,
    this.lightbandWidthPx = 30,
    this.lightbandStrength = 0.9,
    this.lightbandColor = Colors.white,
  });
}

/// Internal widget that creates the render object
class _LiquidGlassRenderWidget extends SingleChildRenderObjectWidget {
  final FragmentShader shader;
  final LiquidGlassSettings settings;
  final double borderRadius;
  final Color color;

  const _LiquidGlassRenderWidget({
    required this.shader,
    required this.settings,
    required this.borderRadius,
    required this.color,
    super.child,
  });

  @override
  _RenderLiquidGlass createRenderObject(BuildContext context) {
    return _RenderLiquidGlass(
      shader: shader,
      settings: settings,
      borderRadius: borderRadius,
      color: color,
      devicePixelRatio: MediaQuery.of(context).devicePixelRatio,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderLiquidGlass renderObject,
  ) {
    renderObject
      ..settings = settings
      ..borderRadius = borderRadius
      ..color = color
      ..devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
  }
}

class _RenderLiquidGlass extends RenderProxyBox {
  final FragmentShader _shader;
  LiquidGlassSettings _settings;
  double _borderRadius;
  Color _color;
  double _devicePixelRatio;

  _RenderLiquidGlass({
    required FragmentShader shader,
    required LiquidGlassSettings settings,
    required double borderRadius,
    required Color color,
    required double devicePixelRatio,
  }) : _shader = shader,
       _settings = settings,
       _borderRadius = borderRadius,
       _color = color,
       _devicePixelRatio = devicePixelRatio;

  set settings(LiquidGlassSettings value) {
    if (_settings == value) return;
    _settings = value;
    markNeedsPaint();
  }

  set borderRadius(double value) {
    if (_borderRadius == value) return;
    _borderRadius = value;
    markNeedsPaint();
  }

  set color(Color value) {
    if (_color == value) return;
    _color = value;
    markNeedsPaint();
  }

  set devicePixelRatio(double value) {
    if (_devicePixelRatio == value) return;
    _devicePixelRatio = value;
    markNeedsPaint();
  }

  @override
  bool get alwaysNeedsCompositing => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!ImageFilter.isShaderFilterSupported || size.isEmpty) {
      super.paint(context, offset);
      return;
    }

    // Get the absolute position and size of this widget
    final transform = getTransformTo(null);
    final rect = MatrixUtils.transformRect(transform, Offset.zero & size);

    // Clamp border radius
    final maxRadius = (rect.width < rect.height ? rect.width : rect.height) / 2;
    final clampedRadius = _borderRadius > maxRadius ? maxRadius : _borderRadius;

    // Configure shader uniforms
    final sh = _shader;
    var idx = 2;

    sh
      // Boundary
      ..setFloat(idx++, rect.left * _devicePixelRatio)
      ..setFloat(idx++, rect.top * _devicePixelRatio)
      ..setFloat(idx++, rect.right * _devicePixelRatio)
      ..setFloat(idx++, rect.bottom * _devicePixelRatio)
      // Blend & refraction
      ..setFloat(idx++, _settings.blendPx * _devicePixelRatio)
      ..setFloat(idx++, _settings.refractStrength)
      ..setFloat(idx++, _settings.distortFalloffPx * _devicePixelRatio)
      ..setFloat(idx++, _settings.distortExponent)
      // Blur
      ..setFloat(idx++, _settings.blurRadiusPx * _devicePixelRatio)
      // Specular
      ..setFloat(idx++, _settings.specAngle)
      ..setFloat(idx++, _settings.specStrength)
      ..setFloat(idx++, _settings.specPower)
      ..setFloat(idx++, _settings.specWidth * _devicePixelRatio)
      // Light band
      ..setFloat(idx++, _settings.lightbandOffsetPx * _devicePixelRatio)
      ..setFloat(idx++, _settings.lightbandWidthPx * _devicePixelRatio)
      ..setFloat(idx++, _settings.lightbandStrength)
      ..setFloat(idx++, _settings.lightbandColor.r)
      ..setFloat(idx++, _settings.lightbandColor.g)
      ..setFloat(idx++, _settings.lightbandColor.b)
      // Anti-aliasing and shape count (always 1 shape now)
      ..setFloat(idx++, 1.0 * _devicePixelRatio)
      ..setFloat(idx++, 1.0)
      // Single shape data
      ..setFloat(idx++, rect.center.dx * _devicePixelRatio)
      ..setFloat(idx++, rect.center.dy * _devicePixelRatio)
      ..setFloat(idx++, rect.width * _devicePixelRatio)
      ..setFloat(idx++, rect.height * _devicePixelRatio)
      ..setFloat(idx++, clampedRadius * _devicePixelRatio)
      ..setFloat(idx++, _color.r)
      ..setFloat(idx++, _color.g)
      ..setFloat(idx++, _color.b)
      ..setFloat(idx++, _color.a);

    // Apply shader as backdrop filter
    context.pushLayer(
      BackdropFilterLayer(filter: ImageFilter.shader(sh)),
      super.paint,
      offset,
    );
  }
}
