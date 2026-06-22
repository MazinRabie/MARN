import 'package:flutter/material.dart';

class TopBounceOnlyScrollPhysics extends ScrollPhysics {
  const TopBounceOnlyScrollPhysics({super.parent});

  @override
  TopBounceOnlyScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return TopBounceOnlyScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    assert(() {
      if (value == position.pixels) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('$runtimeType.applyBoundaryConditions called with redundant value $value.'),
        ]);
      }
      return true;
    }());

    // Prevent bouncing at the bottom (when scrolling past maxScrollExtent)
    if (value > position.pixels && position.pixels >= position.maxScrollExtent) {
      return value - position.pixels; // Clamps the scroll boundary at the bottom
    }

    // Allow default bouncing behavior (e.g. at the top)
    return super.applyBoundaryConditions(position, value);
  }
}
