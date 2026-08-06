import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/utils/attendance/attendance_location_helper.dart';
import 'package:frontendmobile/core/utils/attendance/attendance_token_session.dart';
import 'package:frontendmobile/core/utils/scann/confirm_views.dart';
import 'package:frontendmobile/core/utils/scann/processing_veiw.dart';
import 'package:frontendmobile/core/utils/scann/scanner_header.dart';
import 'package:frontendmobile/core/utils/scann/scanner_veiw.dart';
import 'package:frontendmobile/core/utils/scann/success_veiws.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/providers/attendance_notifier.dart';

enum _ScanStage { scanning, processing, confirming, submitting, done }

class AttendanceScanSheet extends ConsumerStatefulWidget {
  const AttendanceScanSheet({
    super.key,
    required this.companyId,
    this.initialIsCheckIn = true,
  });

  final String companyId;
  final bool initialIsCheckIn;

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  static Future<bool?> show({
    required BuildContext context,
    required String companyId,
    bool initialIsCheckIn = true,
  }) {
    return Navigator.of(context).push<bool>(
      PageRouteBuilder(
        fullscreenDialog: true,
        opaque: true,
        transitionDuration: const Duration(milliseconds: 260),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, __, ___) => AttendanceScanSheet(
          companyId: companyId,
          initialIsCheckIn: initialIsCheckIn,
        ),
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.06),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  ConsumerState<AttendanceScanSheet> createState() =>
      _AttendanceScanSheetState();
}

//////////////////////////////////////////////////////////////////////////////
///
//////////////////////////////////////////////////////////////////////////////

class _AttendanceScanSheetState extends ConsumerState<AttendanceScanSheet> {
  final MobileScannerController _scanner = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  _ScanStage _stage = _ScanStage.scanning;
  late bool _isCheckIn = widget.initialIsCheckIn;
  String? _errorMessage;
  double? _lat;
  double? _lng;

  @override
  void dispose() {
    _scanner.dispose();
    AttendanceTokenSession.instance.clear();
    super.dispose();
  }

  //////////////////////////////////////////////////////////////////////////////
  // ── QR detected → verify + get location → move to confirm step ───────────
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_stage != _ScanStage.scanning || !mounted) return;
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null || raw.isEmpty) return;
    setState(() {
      _errorMessage = null;
      _stage = _ScanStage.processing;
    });
    await _scanner.stop();

    final session = AttendanceTokenSession.instance;
    if (!session.isValid) {
      _setError('Session expired. Please authenticate again.');
      if (mounted) Navigator.pop(context, false);
      return;
    }
    session.attachOfficeQrToken(raw);

    final position = await AttendanceLocationHelper.getCurrentPosition(context);
    if (!mounted) return;
    if (position == null) {
      _setError('Could not get location. Please enable GPS and try again.');
      setState(() => _stage = _ScanStage.scanning);
      return;
    }

    _lat = position.latitude;
    _lng = position.longitude;
    setState(() => _stage = _ScanStage.confirming);
  }

  //////////////////////////////////////////////////////////////////////////////
  // ── User taps Confirm → fires the actual check-in/out ────────────────────
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _confirm() async {
    final session = AttendanceTokenSession.instance;
    final scanToken = session.scanToken;
    if (!session.isValid || scanToken == null || _lat == null || _lng == null) {
      _setError('Session expired. Please try again.');
      return;
    }
    final officeQrToken = session.officeQrToken;
    if (officeQrToken == null || officeQrToken.isEmpty) {
      _setError('Session expired. Please try again.');
      return;
    }

    setState(() {
      _stage = _ScanStage.submitting;
      _errorMessage = null;
    });

    final notifier = ref.read(scanAttendanceProvider.notifier);
    if (_isCheckIn) {
      await notifier.checkIn(
        scanToken: scanToken,
        officeQrToken: officeQrToken,
        latitude: _lat!.toString(),
        longitude: _lng!.toString(),
        companyId: widget.companyId,
      );
    } else {
      await notifier.checkOut(
        scanToken: scanToken,
        officeQrToken: officeQrToken,
        latitude: _lat!.toString(),
        longitude: _lng!.toString(),
        companyId: widget.companyId,
      );
    }
    if (!mounted) return;

    final error = ref.read(scanAttendanceProvider).value?.error;
    if (error != null) {
      setState(() {
        _stage = _ScanStage.confirming;
        _errorMessage = error;
      });
      return;
    }

    setState(() => _stage = _ScanStage.done);
    await Future.delayed(const Duration(milliseconds: 1600));
    if (mounted) Navigator.pop(context, true);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  void _retryScan() {
    setState(() {
      _stage = _ScanStage.scanning;
      _errorMessage = null;
    });
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  void _setError(String msg) {
    if (!mounted) return;
    setState(() => _errorMessage = msg);
  }

  //////////////////////////////////////////////////////////////////////////////
  // ── Build ──────────────────────────────────────────────────────────────
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            Header(
              showClose: _stage != _ScanStage.done,
              onClose: () {
                AttendanceTokenSession.instance.clear();
                Navigator.pop(context, false);
              },
            ),
            Expanded(
              child: switch (_stage) {
                _ScanStage.scanning => ScannerView(
                  controller: _scanner,
                  errorMessage: _errorMessage,
                  onDetect: _onDetect,
                ),
                _ScanStage.processing => const ProcessingView(),
                _ScanStage.confirming || _ScanStage.submitting => ConfirmView(
                  isCheckIn: _isCheckIn,
                  submitting: _stage == _ScanStage.submitting,
                  errorMessage: _errorMessage,
                  onSelect: (v) => setState(() => _isCheckIn = v),
                  onConfirm: _confirm,
                  onRetryScan: _retryScan,
                ),
                _ScanStage.done => SuccessView(isCheckIn: _isCheckIn),
              },
            ),
          ],
        ),
      ),
    );
  }
}
