import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:flutter/material.dart';

class EarningSection extends StatefulWidget {
  final List<MonthlyEarningEntity> monthlyEarning;
  final List<YearlyEarningEntity> yearlyEarning;
  const EarningSection({
    super.key,
    required this.monthlyEarning,
    required this.yearlyEarning,
  });

  @override
  State<EarningSection> createState() => _EarningSectionState();
}

class _EarningSectionState extends State<EarningSection> {
  bool isMonthly = true;

  @override
  Widget build(BuildContext context) {
    return CustomGeneralContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.dashboardReportsEarningsOverview.tr(),
                      style: AppTextStyles.titleLarge,
                    ),
                    Text(
                      isMonthly
                          ? LocaleKeys.dashboardReportsShowingMonthlyGrowth.tr()
                          : LocaleKeys.dashboardReportsShowingYearlyGrowth.tr(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              _ToggleButton(
                isMonthly: isMonthly,
                onChanged: (val) => setState(() => isMonthly = val),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 200,
            child: EarningsChart(
              data: isMonthly ? widget.monthlyEarning : widget.yearlyEarning,
              isMonthly: isMonthly,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ChartLegend(
                label: LocaleKeys.dashboardReportsEarningsLegend.tr(),
                color: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final bool isMonthly;
  final ValueChanged<bool> onChanged;

  const _ToggleButton({required this.isMonthly, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.divider.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleItem(
            text: LocaleKeys.dashboardReportsMonthlyToggle.tr(),
            isSelected: isMonthly,
            onTap: () => onChanged(true),
          ),
          _ToggleItem(
            text: LocaleKeys.dashboardReportsYearlyToggle.tr(),
            isSelected: !isMonthly,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleItem({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class EarningsChart extends StatelessWidget {
  final List<dynamic> data;
  final bool isMonthly;

  const EarningsChart({super.key, required this.data, required this.isMonthly});

  @override
  Widget build(BuildContext context) {
    final List<String> monthNames = [
      LocaleKeys.dashboardReportsJan.tr(),
      LocaleKeys.dashboardReportsFeb.tr(),
      LocaleKeys.dashboardReportsMar.tr(),
      LocaleKeys.dashboardReportsApr.tr(),
      LocaleKeys.dashboardReportsMay.tr(),
      LocaleKeys.dashboardReportsJun.tr(),
      LocaleKeys.dashboardReportsJul.tr(),
      LocaleKeys.dashboardReportsAug.tr(),
      LocaleKeys.dashboardReportsSep.tr(),
      LocaleKeys.dashboardReportsOct.tr(),
      LocaleKeys.dashboardReportsNov.tr(),
      LocaleKeys.dashboardReportsDec.tr(),
    ];

    final ui.TextDirection textDirection = Directionality.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _ChartPainter(
            data: data,
            isMonthly: isMonthly,
            noDataLabel: LocaleKeys.dashboardReportsNoData.tr(),
            monthNames: monthNames,
            textDirection: textDirection,
          ),
        );
      },
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<dynamic> data;
  final bool isMonthly;
  final String noDataLabel;
  final List<String> monthNames;
  final ui.TextDirection textDirection;

  _ChartPainter({
    required this.data,
    required this.isMonthly,
    required this.noDataLabel,
    required this.monthNames,
    required this.textDirection,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double leftPadding = 50;
    const double bottomPadding = 30;
    const double topPadding = 10;
    final double chartWidth = size.width - leftPadding;
    final double chartHeight = size.height - bottomPadding - topPadding;

    // Draw Axes (Optional, matching image)
    final axisPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;

    // X-axis
    canvas.drawLine(
      Offset(leftPadding, size.height - bottomPadding),
      Offset(size.width, size.height - bottomPadding),
      axisPaint,
    );
    // Y-axis
    canvas.drawLine(
      Offset(leftPadding, topPadding),
      Offset(leftPadding, size.height - bottomPadding),
      axisPaint,
    );

    if (data.isEmpty) {
      _drawText(
        canvas,
        Offset(size.width / 2, size.height / 2),
        noDataLabel,
        textAlign: TextAlign.center,
      );
      return;
    }

    final double maxVal = data
        .map(
          (e) =>
              (e is MonthlyEarningEntity
                      ? e.total
                      : (e as YearlyEarningEntity).total)
                  .toDouble(),
        )
        .reduce((a, b) => a > b ? a : b);

    // Round up maxVal for better y-axis labels
    final double effectiveMaxVal = maxVal == 0 ? 18000 : (maxVal * 1.2);
    final List<double> yLabels = [
      0,
      effectiveMaxVal * 0.25,
      effectiveMaxVal * 0.5,
      effectiveMaxVal * 0.75,
      effectiveMaxVal,
    ];

    // Draw Grid and Y-Labels
    final gridPaint = Paint()
      ..color = AppColors.divider.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    for (var label in yLabels) {
      final y =
          size.height - bottomPadding - (label / effectiveMaxVal * chartHeight);

      // Draw grid line (dashed)
      _drawDashedLine(
        canvas,
        Offset(leftPadding, y),
        Offset(size.width, y),
        gridPaint,
      );

      // Draw Y-Label
      _drawText(
        canvas,
        Offset(leftPadding - 10, y),
        label.toStringAsFixed(0),
        textAlign: TextAlign.right,
        fontSize: 10,
      );
    }

    // Prepare Points
    final double stepX = chartWidth / (data.length > 1 ? data.length - 1 : 1);
    final List<Offset> points = [];
    for (int i = 0; i < data.length; i++) {
      final val =
          (data[i] is MonthlyEarningEntity
                  ? data[i].total
                  : (data[i] as YearlyEarningEntity).total)
              .toDouble();
      final x = leftPadding + (i * stepX);
      final y =
          size.height - bottomPadding - (val / effectiveMaxVal * chartHeight);
      points.add(Offset(x, y));

      // Draw X-Labels
      String xLabel = '';
      if (data[i] is MonthlyEarningEntity) {
        xLabel = _getMonthName((data[i] as MonthlyEarningEntity).month);
      } else {
        xLabel = (data[i] as YearlyEarningEntity).year.toString();
      }
      _drawText(
        canvas,
        Offset(x, size.height - bottomPadding + 15),
        xLabel,
        textAlign: TextAlign.center,
        fontSize: 10,
      );
    }

    // Draw Line
    if (points.length > 1) {
      final path = Path();
      path.moveTo(points[0].dx, points[0].dy);

      for (int i = 0; i < points.length - 1; i++) {
        final p1 = points[i];
        final p2 = points[i + 1];
        final controlPoint1 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p1.dy);
        final controlPoint2 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p2.dy);
        path.cubicTo(
          controlPoint1.dx,
          controlPoint1.dy,
          controlPoint2.dx,
          controlPoint2.dy,
          p2.dx,
          p2.dy,
        );
      }

      final linePaint = Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;

      // Draw Fill Gradient
      final fillPath = Path.from(path);
      fillPath.lineTo(points.last.dx, size.height - bottomPadding);
      fillPath.lineTo(points.first.dx, size.height - bottomPadding);
      fillPath.close();

      final fillPaint = Paint()
        ..shader =
            LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary.withValues(alpha: 0.3),
                AppColors.primary.withValues(alpha: 0.0),
              ],
            ).createShader(
              Rect.fromLTRB(0, 0, size.width, size.height - bottomPadding),
            );

      canvas.drawPath(fillPath, fillPaint);
      canvas.drawPath(path, linePaint);

      // Draw Points (Circles)
      for (final p in points) {
        canvas.drawCircle(p, 5, Paint()..color = Colors.white);
        canvas.drawCircle(
          p,
          5,
          linePaint
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
    } else if (points.length == 1) {
      canvas.drawCircle(points[0], 6, Paint()..color = AppColors.primary);
    }
  }

  void _drawText(
    Canvas canvas,
    Offset offset,
    String text, {
    TextAlign textAlign = TextAlign.left,
    double fontSize = 12,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: AppColors.textTertiary, fontSize: fontSize),
      ),
      textDirection: textDirection,
      textAlign: textAlign,
    )..layout();

    final x = textAlign == TextAlign.right
        ? offset.dx - textPainter.width
        : textAlign == TextAlign.center
        ? offset.dx - textPainter.width / 2
        : offset.dx;

    textPainter.paint(canvas, Offset(x, offset.dy - textPainter.height / 2));
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const double dashWidth = 5;
    const double dashSpace = 5;
    double currentX = p1.dx;
    while (currentX < p2.dx) {
      canvas.drawLine(
        Offset(currentX, p1.dy),
        Offset(currentX + dashWidth, p1.dy),
        paint,
      );
      currentX += dashWidth + dashSpace;
    }
  }

  String _getMonthName(int month) {
    if (month >= 1 && month <= 12) return monthNames[month - 1];
    return '';
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _ChartLegend extends StatelessWidget {
  final String label;
  final Color color;

  const _ChartLegend({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
