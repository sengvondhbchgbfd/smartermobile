class AttendanceTokenSession {
  AttendanceTokenSession._();
  static final AttendanceTokenSession instance = AttendanceTokenSession._();

  static const Duration _ttl = Duration(minutes: 15);

  String? _scanToken;
  String? _officeQrToken;
  DateTime? _issuedAt;

  // ── Public getters ────────────────────────────────────────────────────────

  /// True when a scan-token exists and is still within the 15-minute window.
  bool get isValid {
    if (_scanToken == null || _issuedAt == null) return false;
    return DateTime.now().difference(_issuedAt!) < _ttl;
  }

  String? get scanToken => isValid ? _scanToken : null;
  String? get officeQrToken => isValid ? _officeQrToken : null;

  /// Remaining seconds until expiry (0 when expired / not set).
  int get remainingSeconds {
    if (!isValid) return 0;
    final elapsed = DateTime.now().difference(_issuedAt!);
    return (_ttl.inSeconds - elapsed.inSeconds).clamp(0, _ttl.inSeconds);
  }

  // ── Mutators ──────────────────────────────────────────────────────────────

  /// Call this after a successful password-auth + office-QR fetch.
  void save({required String scanToken, required String officeQrToken}) {
    _scanToken = scanToken;
    _officeQrToken = officeQrToken;
    _issuedAt = DateTime.now();
  }

  /// Invalidate manually (e.g. on logout).
  void clear() {
    _scanToken = null;
    _officeQrToken = null;
    _issuedAt = null;
  }
}