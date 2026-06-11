import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/providers/wizard_provider.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';
import 'package:image_picker/image_picker.dart';

class Step4AvatarScreen extends ConsumerStatefulWidget {
  const Step4AvatarScreen({super.key});
  @override
  ConsumerState<Step4AvatarScreen> createState() => _Step4AvatarState();
}

class _Step4AvatarState extends ConsumerState<Step4AvatarScreen> {
  String? _pickedPath;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) setState(() => _pickedPath = picked.path);
  }

  ////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////

  Future<void> _upload() async {
    if (_pickedPath == null) return;

    ////////////////////
    ////
    /////////////////////
    final storage = ref.read(secureStorageProvider);
    final staffIdStr = await storage.getUserInfo().then(
      (info) => info?["staff_id"],
    );
    /////////////////////
    //
    /////////////////////

    final staffId = int.tryParse(staffIdStr ?? '');
    if (staffId == null) {
      ref.read(wizardProvider.notifier).nextStep();
      return;
    }
    await ref
        .read(wizardProvider.notifier)
        .uploadAvatar(filePath: _pickedPath!, staffId: staffId);
  }

  //////////////////////////////////////////////////
  ///
  /////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    //////////////////////////////////////////////
    final state = ref.watch(wizardProvider);
    final isLoading = state.isLoading;

    /////////////////////////////////////////////

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: const Color(0xFF0F172A),
                  backgroundImage: _pickedPath != null
                      ? FileImage(File(_pickedPath!))
                      : null,
                  child: _pickedPath == null
                      ? const Icon(
                          Icons.person,
                          color: Colors.white38,
                          size: 48,
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF6366F1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          /////////////////////////////////////////////////////
          const SizedBox(height: 16),
          ////////////////////////////////////////////////////
          const Text(
            'Tap to choose a photo',
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),
          if (state.error != null) ...[
            const SizedBox(height: 12),
            Text(
              state.error!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 13),
            ),
          ],
          //////////////////////////////////////////////////////
          const Spacer(),

          //////////////////////////////////////////////////////
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => ref.read(wizardProvider.notifier).nextStep(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ),

              //////////////////////////////////////////////////////
              const SizedBox(width: 12),
              //////////////////////////////////////////////////////
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: isLoading || _pickedPath == null ? null : _upload,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    disabledBackgroundColor: Colors.white12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),

                  //////////////////////////////////////////
                  ///
                  //////////////////////////////////////////
                  ///
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
                          'Upload',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
