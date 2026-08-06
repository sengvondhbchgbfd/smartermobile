class AttendanceTokenSession {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  AttendanceTokenSession._();
  static final AttendanceTokenSession instance = AttendanceTokenSession._();
  static const Duration _ttl = Duration(minutes: 15);
  String? _scanToken;
  String? _officeQrToken;
  DateTime? _issuedAt;

  //////////////////////////////////////////////////////////////////////////////
  // ── Public getters ────────────────────────────────────────────────────────
  //////////////////////////////////////////////////////////////////////////////

  bool get isValid {
    if (_scanToken == null || _issuedAt == null) return false;
    return DateTime.now().difference(_issuedAt!) < _ttl;
  }

  String? get scanToken => isValid ? _scanToken : null;
  String? get officeQrToken => isValid ? _officeQrToken : null;

  int get remainingSeconds {
    if (!isValid) return 0;
    final elapsed = DateTime.now().difference(_issuedAt!);
    return (_ttl.inSeconds - elapsed.inSeconds).clamp(0, _ttl.inSeconds);
  }

  //////////////////////////////////////////////////////////////////////////////
  // ── Mutators ──────────────────────────────────────────────────────────────
  //////////////////////////////////////////////////////////////////////////////
  void save({required String scanToken, String? officeQrToken}) {
    _scanToken = scanToken;
    if (officeQrToken != null) {
      _officeQrToken = officeQrToken;
    }
    _issuedAt = DateTime.now();
  }

  void attachOfficeQrToken(String token) {
    _officeQrToken = token;
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Invalidate manually (e.g. on logout).
  //////////////////////////////////////////////////////////////////////////////
  void clear() {
    _scanToken = null;
    _officeQrToken = null;
    _issuedAt = null;
  }
}
