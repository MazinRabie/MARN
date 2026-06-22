import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// ─── Data Model ───────────────────────────────────────────────────────────────

class DateParts {
  int? day;
  int? month;
  int? year;

  bool get isComplete => day != null && month != null && year != null;

  DateTime? toDateTime() {
    if (!isComplete) return null;
    return DateTime.utc(year!, month!, day!);
  }
}

// ─── Widget ───────────────────────────────────────────────────────────────────

class SmartRangePicker extends StatefulWidget {
  final EnumItem rentalUnit;

  /// Called whenever a valid range is selected.
  /// Dates are formatted as UTC ISO 8601: "2026-05-31T18:51:22.966Z"
  final void Function({required String? start, required String? end}) onChanged;

  /// Optional error messages shown below the widget on validation failure
  final String? startRequiredMessage;
  final String? endRequiredMessage;

  const SmartRangePicker({
    super.key,
    required this.rentalUnit,
    required this.onChanged,
    this.startRequiredMessage,
    this.endRequiredMessage,
  });

  @override
  State<SmartRangePicker> createState() => _SmartRangePickerState();
}

class _SmartRangePickerState extends State<SmartRangePicker> {
  final _startParts = DateParts();
  final _endParts = DateParts();

  // Computed DateTimes (null if not yet complete)
  DateTime? _startDt;
  DateTime? _endDt;

  late String _unit;

  @override
  void initState() {
    super.initState();
    _unit = widget.rentalUnit.name.toLowerCase();
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  /// Returns the last valid day in a given month/year
  int _lastDayOfMonth(int year, int month) => DateTime(year, month + 1, 0).day;

  /// Converts a DateTime to UTC ISO 8601 string: "2026-05-31T18:51:22.966Z"
  String _toIso(DateTime dt) => dt.toUtc().toIso8601String();

  // ─── Date Calculation (mirrors C# IsDurationDivisible) ────────────────────
  //
  //  Daily  → end > start, same TimeOfDay (both midnight → any full day diff)
  //  Monthly→ start.AddMonths(n) == end  →  end.day == start.day (clamped)
  //  Yearly → start.AddYears(n)  == end  →  end.day == start.day && end.month == start.month

  void _compute() {
    _startDt = _startParts.toDateTime();

    switch (_unit) {
      case 'daily':
        _endDt = _endParts.toDateTime();
        break;

      case 'monthly':
        if (_endParts.month != null &&
            _endParts.year != null &&
            _startParts.day != null) {
          // Clamp day to last valid day of the selected month (matches .NET AddMonths)
          final day = _startParts.day!.clamp(
            1,
            _lastDayOfMonth(_endParts.year!, _endParts.month!),
          );
          _endDt = DateTime.utc(_endParts.year!, _endParts.month!, day);
        } else {
          _endDt = null;
        }
        break;

      case 'yearly':
        if (_endParts.year != null &&
            _startParts.day != null &&
            _startParts.month != null) {
          // Clamp day to last valid day of start month in the end year
          final day = _startParts.day!.clamp(
            1,
            _lastDayOfMonth(_endParts.year!, _startParts.month!),
          );
          _endDt = DateTime.utc(_endParts.year!, _startParts.month!, day);
        } else {
          _endDt = null;
        }
        break;
    }

    widget.onChanged(
      start: _startDt != null ? _toIso(_startDt!) : null,
      end: _endDt != null ? _toIso(_endDt!) : null,
    );
  }

  // ─── The actual end day shown in derived boxes (clamped) ──────────────────

  String _effectiveEndDay() {
    if (_startParts.day == null) return '--';
    if (_unit == 'monthly' &&
        _endParts.month != null &&
        _endParts.year != null) {
      final clamped = _startParts.day!.clamp(
        1,
        _lastDayOfMonth(_endParts.year!, _endParts.month!),
      );
      return clamped.toString().padLeft(2, '0');
    }
    if (_unit == 'yearly' &&
        _endParts.year != null &&
        _startParts.month != null) {
      final clamped = _startParts.day!.clamp(
        1,
        _lastDayOfMonth(_endParts.year!, _startParts.month!),
      );
      return clamped.toString().padLeft(2, '0');
    }
    return _fmtDay(_startParts);
  }

  // ─── Pickers ──────────────────────────────────────────────────────────────

  Future<void> _pickStartDate(FormFieldState<bool> state) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _startParts.toDateTime() ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) {
      setState(() {
        _startParts.day = picked.day;
        _startParts.month = picked.month;
        _startParts.year = picked.year;
        // Reset end when start changes
        _endParts.day = null;
        _endParts.month = null;
        _endParts.year = null;
        _endDt = null;
      });
      _compute();
      state.didChange(_startDt != null);
    }
  }

  Future<void> _pickEndDate(FormFieldState<bool> state) async {
    final minDate = _startParts.toDateTime() ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _endParts.toDateTime() ?? minDate.add(const Duration(days: 1)),
      firstDate: minDate.add(const Duration(days: 1)),
      lastDate: DateTime(minDate.year + 10),
    );
    if (picked != null) {
      setState(() {
        _endParts.day = picked.day;
        _endParts.month = picked.month;
        _endParts.year = picked.year;
      });
      _compute();
      state.didChange(_endDt != null);
    }
  }

  Future<void> _pickEndMonth(FormFieldState<bool> state) async {
    final startYear = _startParts.year ?? DateTime.now().year;
    final startMonth = _startParts.month ?? DateTime.now().month;

    int selYear = _endParts.year ?? startYear;
    int selMonth = _endParts.month ?? startMonth;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDs) => AlertDialog(
          title: Text(LocaleKeys.propertyBookingSelectEndMonthYear.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed:
                        (selYear > startYear ||
                            (selYear == startYear && selMonth > startMonth))
                        ? () => setDs(() => selYear--)
                        : null,
                  ),
                  Text('$selYear', style: AppTextStyles.titleMedium),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => setDs(() => selYear++),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                childAspectRatio: 1.5,
                children: List.generate(12, (i) {
                  final m = i + 1;
                  final isDisabled = selYear == startYear && m <= startMonth;
                  final isSelected = m == selMonth;
                  return GestureDetector(
                    onTap: isDisabled ? null : () => setDs(() => selMonth = m),
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDisabled
                              ? AppColors.textHint
                              : AppColors.primary,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _monthShort(m),
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.white
                                : isDisabled
                                ? AppColors.textHint
                                : AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(LocaleKeys.propertyButtonsCancel.tr()),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _endParts.month = selMonth;
                  _endParts.year = selYear;
                });
                _compute();
                state.didChange(_endDt != null);
                Navigator.pop(ctx);
              },
              child: Text(LocaleKeys.propertyButtonsConfirm.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickEndYear(FormFieldState<bool> state) async {
    final startYear = _startParts.year ?? DateTime.now().year;
    int selYear = _endParts.year ?? (startYear + 1);

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDs) => AlertDialog(
          title: Text(LocaleKeys.propertyBookingSelectEndYear.tr()),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: selYear > startYear + 1
                    ? () => setDs(() => selYear--)
                    : null,
              ),
              Text('$selYear', style: AppTextStyles.titleLarge),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => setDs(() => selYear++),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(LocaleKeys.propertyButtonsCancel.tr()),
            ),
            FilledButton(
              onPressed: () {
                setState(() => _endParts.year = selYear);
                _compute();
                state.didChange(_endDt != null);
                Navigator.pop(ctx);
              },
              child: Text(LocaleKeys.propertyButtonsConfirm.tr()),
            ),
          ],
        ),
      ),
    );
  }

  // ─── UI Helpers ───────────────────────────────────────────────────────────

  String _monthShort(int m) {
    switch (m) {
      case 1:
        return LocaleKeys.propertyMonthsJan.tr();
      case 2:
        return LocaleKeys.propertyMonthsFeb.tr();
      case 3:
        return LocaleKeys.propertyMonthsMar.tr();
      case 4:
        return LocaleKeys.propertyMonthsApr.tr();
      case 5:
        return LocaleKeys.propertyMonthsMay.tr();
      case 6:
        return LocaleKeys.propertyMonthsJun.tr();
      case 7:
        return LocaleKeys.propertyMonthsJul.tr();
      case 8:
        return LocaleKeys.propertyMonthsAug.tr();
      case 9:
        return LocaleKeys.propertyMonthsSep.tr();
      case 10:
        return LocaleKeys.propertyMonthsOct.tr();
      case 11:
        return LocaleKeys.propertyMonthsNov.tr();
      case 12:
        return LocaleKeys.propertyMonthsDec.tr();
      default:
        return '--';
    }
  }

  String _fmtDay(DateParts p) =>
      p.day != null ? p.day.toString().padLeft(2, '0') : '--';
  String _fmtMonth(DateParts p) =>
      p.month != null ? _monthShort(p.month!) : '--';
  String _fmtYear(DateParts p) => p.year?.toString() ?? '----';

  Widget _activeBox({
    required String label,
    required String value,
    required void Function(FormFieldState<bool>) onTap,
    required FormFieldState<bool> state,
    bool filled = false,
    bool hasError = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(state),
        child: Container(
          height: 64,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: filled ? AppColors.primaryContainer : AppColors.surface,
            border: Border.all(
              color: hasError
                  ? Colors.red
                  : filled
                  ? AppColors.primary
                  : AppColors.border,
              width: filled ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: hasError ? Colors.red : AppColors.textHint,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: filled ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _derivedBox({required String label, required String value}) {
    return Expanded(
      child: Container(
        height: 64,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textHint,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text, {bool hasError = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: AppTextStyles.bodyMedium.copyWith(
        color: hasError ? Colors.red : AppColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _errorText(String message) => Padding(
    padding: const EdgeInsets.only(top: 6, left: 4),
    child: Text(
      message,
      style: const TextStyle(color: Colors.red, fontSize: 12),
    ),
  );

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: false,
      validator: (_) {
        if (_startDt == null) {
          return widget.startRequiredMessage ?? LocaleKeys.propertyBookingStartRequired.tr();
        }
        if (_endDt == null) {
          return widget.endRequiredMessage ?? LocaleKeys.propertyBookingEndRequired.tr();
        }
        return null;
      },
      builder: (state) {
        final startError = state.hasError && _startDt == null;
        final endError = state.hasError && _startDt != null && _endDt == null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Start: always Day / Month / Year ─────────────
            _sectionLabel(LocaleKeys.propertyBookingStartDate.tr(), hasError: startError),
            Row(
              children: [
                _activeBox(
                  label: LocaleKeys.propertyBookingDay.tr(),
                  value: _fmtDay(_startParts),
                  onTap: _pickStartDate,
                  state: state,
                  filled: _startParts.day != null,
                  hasError: startError,
                ),
                _activeBox(
                  label: LocaleKeys.propertyBookingMonth.tr(),
                  value: _fmtMonth(_startParts),
                  onTap: _pickStartDate,
                  state: state,
                  filled: _startParts.month != null,
                  hasError: startError,
                ),
                _activeBox(
                  label: LocaleKeys.propertyBookingYear.tr(),
                  value: _fmtYear(_startParts),
                  onTap: _pickStartDate,
                  state: state,
                  filled: _startParts.year != null,
                  hasError: startError,
                ),
              ],
            ),
            if (startError) _errorText(state.errorText!),

            const SizedBox(height: 16),

            // ── End: fields depend on RentalUnit ─────────────
            _sectionLabel(LocaleKeys.propertyBookingEndDate.tr(), hasError: endError),
            Row(
              children: [
                // Daily → all 3 active (user picks full date)
                if (_unit == 'daily') ...[
                  _activeBox(
                    label: LocaleKeys.propertyBookingDay.tr(),
                    value: _fmtDay(_endParts),
                    onTap: _pickEndDate,
                    state: state,
                    filled: _endParts.day != null,
                    hasError: endError,
                  ),
                  _activeBox(
                    label: LocaleKeys.propertyBookingMonth.tr(),
                    value: _fmtMonth(_endParts),
                    onTap: _pickEndDate,
                    state: state,
                    filled: _endParts.month != null,
                    hasError: endError,
                  ),
                  _activeBox(
                    label: LocaleKeys.propertyBookingYear.tr(),
                    value: _fmtYear(_endParts),
                    onTap: _pickEndDate,
                    state: state,
                    filled: _endParts.year != null,
                    hasError: endError,
                  ),
                ],

                // Monthly → Day derived from start (clamped), Month+Year active
                if (_unit == 'monthly') ...[
                  _derivedBox(label: LocaleKeys.propertyBookingDay.tr(), value: _effectiveEndDay()),
                  _activeBox(
                    label: LocaleKeys.propertyBookingMonth.tr(),
                    value: _fmtMonth(_endParts),
                    onTap: _pickEndMonth,
                    state: state,
                    filled: _endParts.month != null,
                    hasError: endError,
                  ),
                  _activeBox(
                    label: LocaleKeys.propertyBookingYear.tr(),
                    value: _fmtYear(_endParts),
                    onTap: _pickEndMonth,
                    state: state,
                    filled: _endParts.year != null,
                    hasError: endError,
                  ),
                ],

                // Yearly → Day+Month derived from start (day clamped), Year active
                if (_unit == 'yearly') ...[
                  _derivedBox(label: LocaleKeys.propertyBookingDay.tr(), value: _effectiveEndDay()),
                  _derivedBox(label: LocaleKeys.propertyBookingMonth.tr(), value: _fmtMonth(_startParts)),
                  _activeBox(
                    label: LocaleKeys.propertyBookingYear.tr(),
                    value: _fmtYear(_endParts),
                    onTap: _pickEndYear,
                    state: state,
                    filled: _endParts.year != null,
                    hasError: endError,
                  ),
                ],
              ],
            ),
            if (endError) _errorText(state.errorText!),
          ],
        );
      },
    );
  }
}
