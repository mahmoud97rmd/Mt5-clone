// Path: lib/features/ea/presentation/screens/ea_setup_sheet.dart
// ============================================================
// MT5 Clone — EA Setup Sheet
// Bottom sheet for creating/configuring a new EA instance.
// ============================================================

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app/app_theme.dart';
import '../../../../core/domain/entities/ea_entities.dart';

import '../../data/datasources/ea_engine_channel.dart';
import '../../data/datasources/file_picker_channel.dart';
import '../../data/repositories/ea_repository_impl.dart';

class EaSetupSheet extends ConsumerStatefulWidget {
  const EaSetupSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => const EaSetupSheet(),
    );
  }

  @override
  ConsumerState<EaSetupSheet> createState() => _EaSetupSheetState();
}

class _EaSetupSheetState extends ConsumerState<EaSetupSheet> {
  final _nameController = TextEditingController();
  final _symbolController = TextEditingController(text: 'EUR_USD');
  final _lotController = TextEditingController(text: '0.01');
  final _magicController = TextEditingController(text: '1000');
  final _maxPosController = TextEditingController(text: '5');
  final _killTimeoutController = TextEditingController(text: '30');
  final _dailyLossController = TextEditingController(text: '100');

  String? _scriptPath;
  String? _scriptName;
  bool _isSaving = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _symbolController.dispose();
    _lotController.dispose();
    _magicController.dispose();
    _maxPosController.dispose();
    _killTimeoutController.dispose();
    _dailyLossController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return ListView(
            controller: scrollController,
            padding: EdgeInsets.all(16.w),
            children: [
              // ── Handle ──────────────────────────────────────
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: AppTheme.textMuted,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              Text(
                'New Expert Advisor',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 16.h),

              // ── Script Picker ───────────────────────────────
              _SectionLabel(label: 'Python Script'),
              SizedBox(height: 4.h),
              InkWell(
                onTap: _pickScript,
                borderRadius: BorderRadius.circular(6.r),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                        color: _scriptPath != null
                            ? AppTheme.primaryTeal
                            : AppTheme.surfaceBorder),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.attach_file,
                          size: 18.sp, color: AppTheme.textMuted),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          _scriptName ?? 'Tap to select .py file',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            color: _scriptPath != null
                                ? AppTheme.textPrimary
                                : AppTheme.textDisabled,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (_scriptPath != null)
                        Icon(Icons.check_circle,
                            size: 18.sp, color: AppTheme.primaryTeal),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // ── EA Name ────────────────────────────────────
              _InputField(
                label: 'EA Name',
                controller: _nameController,
                hint: 'My Trading Bot',
              ),
              SizedBox(height: 12.h),

              // ── Symbol ─────────────────────────────────────
              _InputField(
                label: 'Symbol',
                controller: _symbolController,
                hint: 'EUR_USD',
              ),
              SizedBox(height: 12.h),

              // ── Lot Size + Magic Number ────────────────────
              Row(
                children: [
                  Expanded(
                    child: _InputField(
                      label: 'Lot Size',
                      controller: _lotController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _InputField(
                      label: 'Magic Number',
                      controller: _magicController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // ── Risk Settings ──────────────────────────────
              _SectionLabel(label: 'Risk Settings'),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Expanded(
                    child: _InputField(
                      label: 'Max Positions',
                      controller: _maxPosController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _InputField(
                      label: 'Kill Timeout (s)',
                      controller: _killTimeoutController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              _InputField(
                label: 'Daily Loss Limit',
                controller: _dailyLossController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                hint: '100.00',
              ),
              SizedBox(height: 16.h),

              // ── Error ───────────────────────────────────────
              if (_error != null)
                Container(
                  padding: EdgeInsets.all(8.w),
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: AppTheme.sellRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    _error!,
                    style: GoogleFonts.inter(
                        fontSize: 12.sp, color: AppTheme.sellRed),
                  ),
                ),

              // ── Save Button ─────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryTeal,
                    foregroundColor: AppTheme.backgroundPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: _isSaving
                      ? SizedBox(
                          width: 20.sp,
                          height: 20.sp,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.backgroundPrimary,
                          ),
                        )
                      : Text(
                          'Save EA',
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 8.h),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickScript() async {
    final picker = ref.read(filePickerChannelProvider);
    final path = await picker.pickPythonFile();
    if (path != null) {
      setState(() {
        _scriptPath = path;
        _scriptName = picker.getFileName(path);
        if (_nameController.text.isEmpty) {
          _nameController.text =
              _scriptName!.replaceAll('.py', '').replaceAll('_', ' ');
        }
      });
    }
  }

  Future<void> _save() async {
    if (_scriptPath == null) {
      setState(() => _error = 'Please select a Python script');
      return;
    }
    if (_nameController.text.trim().isEmpty) {
      setState(() => _error = 'Please enter an EA name');
      return;
    }

    setState(() {
      _isSaving = true;
      _error = null;
    });

    // Copy script to app directory
    final channel = ref.read(eaEngineChannelProvider);
    final scriptPath = await channel.copyScriptToAppDir(_scriptPath!);

    final ea = EaInstanceEntity(
      name: _nameController.text.trim(),
      symbol: _symbolController.text.trim(),
      scriptPath: scriptPath,
      magicNumber: int.tryParse(_magicController.text) ?? 1000,
      lotSize: double.tryParse(_lotController.text) ?? 0.01,
      maxPositions: int.tryParse(_maxPosController.text) ?? 5,
      killSwitchTimeoutSeconds:
          int.tryParse(_killTimeoutController.text) ?? 30,
      dailyLossLimit: double.tryParse(_dailyLossController.text) ?? 100,
      createdAt: DateTime.now(),
      customParams: {},
    );

    final repo = ref.read(eaRepositoryProvider);
    final result = await repo.saveEaInstance(ea);

    result.fold(
      (failure) {
        setState(() {
          _isSaving = false;
          _error = failure.message;
        });
      },
      (_) {
        Navigator.pop(context);
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: AppTheme.textSecondary,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? hint;

  const _InputField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
        SizedBox(height: 4.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 14.sp,
            color: AppTheme.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 13.sp,
              color: AppTheme.textDisabled,
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            filled: true,
            fillColor: AppTheme.surfaceElevated,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: const BorderSide(color: AppTheme.surfaceBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: const BorderSide(color: AppTheme.surfaceBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: const BorderSide(
                  color: AppTheme.primaryTeal, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
