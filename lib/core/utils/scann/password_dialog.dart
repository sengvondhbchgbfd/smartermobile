import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class PasswordDialog extends StatefulWidget {
  final Future<String?> Function(String password) onSubmit;

  const PasswordDialog({super.key, required this.onSubmit});

  @override
  State<PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _obscure = true;
  bool _loading = false;
  String? _errorText;
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted) _focusNode.requestFocus();
      });
    });
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  void _cancel() {
    if (_loading) return;
    Navigator.pop(context, false);
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _submit() async {
    if (_loading) return;
    final pwd = _controller.text;
    if (pwd.isEmpty) {
      setState(() => _errorText = 'Please enter your password.');
      return;
    }
    setState(() {
      _loading = true;
      _errorText = null;
    });
    final error = await widget.onSubmit(pwd);
    if (!mounted) return;
    if (error == null) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        _loading = false;
        _errorText = error;
      });
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    //////////////////////////////////////////////////////////////////////////////
    ///
    //////////////////////////////////////////////////////////////////////////////
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final surface = isDark ? Pallets.surfaceElevated : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    //////////////////////////////////////////////////////////////////////////////
    ///
    //////////////////////////////////////////////////////////////////////////////

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: bg,
      body: SafeArea(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: _loading ? null : _cancel,
                      icon: Icon(Icons.close, color: textPrimary),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: Pallets.brandGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Pallets.blurple.withOpacity(0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.lock_outline,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Authentication Required',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter your password to unlock attendance for 1 minute.',
                          style: TextStyle(
                            fontSize: 14,
                            color: textSecondary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 32),
                        ////////////////////////////////////////////////////////
                        ///
                        ////////////////////////////////////////////////////////
                        TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          obscureText: _obscure,
                          enabled: !_loading,
                          textInputAction: TextInputAction.done,
                          style: TextStyle(color: textPrimary),
                          onSubmitted: (_) => _submit(),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: textSecondary),
                            filled: true,
                            fillColor: surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Pallets.blurple,
                                width: 1.5,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: textSecondary,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: textSecondary,
                              ),
                              onPressed: _loading
                                  ? null
                                  : () => setState(() => _obscure = !_obscure),
                            ),
                          ),
                        ),
                        ////////////////////////////////////////////////////////
                        ///
                        ////////////////////////////////////////////////////////
                        if (_errorText != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Pallets.errorTint,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Pallets.error,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorText!,
                                    style: const TextStyle(
                                      color: Pallets.error,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Pallets.blurple,
                      disabledBackgroundColor: Pallets.blurple.withOpacity(0.6),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Text(
                            'Confirm',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: TextButton(
                    onPressed: _loading ? null : _cancel,
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: textSecondary),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
