part of 'home_entry_card.dart';

class _HomeEntryCardBackgroundSweepAnimation extends StatefulWidget {
  const _HomeEntryCardBackgroundSweepAnimation({
    required this.child,
    required this.enabled,
  });

  final Widget child;
  final bool enabled;

  @override
  State<_HomeEntryCardBackgroundSweepAnimation> createState() =>
      _BackgroundSweepAnimationState();
}

class _BackgroundSweepAnimationState
    extends State<_HomeEntryCardBackgroundSweepAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        padding: widget.enabled ? const EdgeInsets.all(1.0) : null,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
          gradient: widget.enabled
              ? SweepGradient(
                  startAngle: controller.value * pi * 2,
                  endAngle: controller.value * pi * 2 + pi,
                  tileMode: TileMode.mirror,
                  colors: const [
                    Colors.white70,
                    Colors.black54,
                    Colors.white,
                    Colors.white,
                    Colors.black54,
                    Colors.white70,
                  ],
                )
              : null,
        ),
        child: widget.child,
      ),
    );
  }
}
