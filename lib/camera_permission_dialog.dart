import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

class CameraPermissionDialog extends StatelessWidget {
  const CameraPermissionDialog({super.key});

  static show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CameraPermissionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Allow Chrome to use your camera',
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w500, height: 1.4),
                  ),
                  const Text(
                    '1. In System Settings, open Privacy &Security',
                    style: TextStyle(
                      fontSize: 18,
                      height: 2,
                    ),
                  ),
                  const Text(
                    '2. Allow Chrome to access your camera',
                    style: TextStyle(
                      fontSize: 18,
                      height: 2,
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        AppSettings.openAppSettings(type: AppSettingsType.camera);
                      },
                      child: const Text('Open System Settings'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
