import 'package:flutter/material.dart';

class WizardButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSkip;
  final VoidCallback onSubmit;

  const WizardButtons({
    super.key,
    required this.isLoading,
    required this.onSkip,
    required this.onSubmit,
  });




  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ///////////////////////////////////////////////////////////
        /// Skip button
        /// ////////////////////////////////////////////////////////
        Expanded(
          child: OutlinedButton(
            onPressed: isLoading ? null : onSkip,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color.fromRGBO(11, 3, 255, 0.239)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text(
              'Skip',
              style: TextStyle(color: Color.fromARGB(137, 237, 225, 4)),
            ),
          ),
        ),

        const SizedBox(width: 12),

        ///////////////////////////////////////////////////////////
        /// Continue button
        /// ///////////////////////////////////////////////////////
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: isLoading ? null : onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
