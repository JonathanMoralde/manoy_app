import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manoy_app/provider/home/activeDisplay_provider.dart';

class SliderBar extends ConsumerWidget {
  const SliderBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeDisplay = ref.watch(activeDisplayProvider);
    return Align(
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: 0.5,
        child: Container(
          width: double.infinity,
          height: 3,
          decoration: BoxDecoration(
            color: Color(0xFF00A2FF),
          ),
        ),
      ),
    )
        .animate(target: activeDisplay == "Find Shops" ? 1 : 0)
        .slideX(curve: Curves.linear);
  }
}
