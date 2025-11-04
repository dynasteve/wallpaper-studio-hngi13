import 'package:flutter/material.dart';

class WallpaperSetupSidePanel extends StatefulWidget {
  const WallpaperSetupSidePanel({super.key});

  @override
  State<WallpaperSetupSidePanel> createState() =>
      _WallpaperSetupSidePanelState();
}

class _WallpaperSetupSidePanelState extends State<WallpaperSetupSidePanel> {
  bool isActivated = true;
  bool autoRotation = false;
  String displayMode = 'Fit';
  bool lockWallpaper = false;
  bool syncAcrossDevices = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Text(
                  "Wallpaper Setup",
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Configure your wallpaper settings and enable auto-rotation",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildToggleCard(
                          title: "Active Wallpaper",
                          description:
                              "Set the selected wallpaper as your desktop background",
                          value: isActivated,
                          onChanged: (val) => setState(() => isActivated = val),
                          activeColor: Colors.green.shade100,
                          activeTextColor: Colors.green.shade700,
                          activeLabel: "Activated",
                        ),
                        const SizedBox(height: 16),

                        _buildDisplayModeSection(),
                        const SizedBox(height: 16),

                        _buildToggleCard(
                          title: "Auto-Rotation",
                          description:
                              "Automatically change your wallpaper at regular intervals",
                          value: autoRotation,
                          onChanged: (val) =>
                              setState(() => autoRotation = val),
                          activeColor: Colors.green.shade100,
                          activeTextColor: Colors.green.shade700,
                        ),
                        const SizedBox(height: 16),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Advanced Settings",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildCheckboxCard(
                          title: "Lock Wallpaper",
                          description: "Prevent accidental changes",
                          value: lockWallpaper,
                          onChanged: (val) =>
                              setState(() => lockWallpaper = val!),
                        ),
                        const SizedBox(height: 12),
                        _buildCheckboxCard(
                          title: "Sync Across Devices",
                          description:
                              "Keep wallpaper consistent on all devices",
                          value: syncAcrossDevices,
                          onChanged: (val) =>
                              setState(() => syncAcrossDevices = val!),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildButton(
                      label: "Cancel",
                      color: const Color(0xFFF8F8F8),
                      textColor: Colors.black,
                      borderColor: const Color(0xFFDFDFDF),
                      onPressed: () => Navigator.pop(context),
                    ),
                    _buildButton(
                      label: "Save Settings",
                      color: const Color(0xFFFBB03B),
                      textColor: Colors.white,
                      onPressed: () {
                        // TODO: Save settings logic
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Reusable Components ---
  Widget _buildToggleCard({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
    Color? activeColor,
    Color? activeTextColor,
    String activeLabel = "Enabled",
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: value ? (activeColor ?? Colors.green.shade50) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // Left text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(description,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: Colors.black54)),
              ],
            ),
          ),

          // Toggle button
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: value
                    ? (activeColor ?? Colors.green.shade100)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(
                    value ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: value
                        ? (activeTextColor ?? Colors.green.shade700)
                        : Colors.grey,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    value ? activeLabel : "Off",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: value
                          ? (activeTextColor ?? Colors.green.shade700)
                          : Colors.black54,
                      fontWeight:
                          value ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayModeSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Display Mode",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildRadioOption(
              title: "Fit",
              description: "Scale to fit without cropping",
              value: "Fit"),
          _buildRadioOption(
              title: "Fill",
              description: "Scale to fill the entire screen",
              value: "Fill"),
          _buildRadioOption(
              title: "Stretch",
              description: "Stretch to fill the screen",
              value: "Stretch"),
          _buildRadioOption(
              title: "Tile",
              description: "Repeat the image to fill the screen",
              value: "Tile"),
        ],
      ),
    );
  }

  Widget _buildRadioOption({
    required String title,
    required String description,
    required String value,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Radio<String>(
        value: value,
        groupValue: displayMode,
        activeColor: const Color(0xFFFBB03B),
        onChanged: (val) => setState(() => displayMode = val!),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        description,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildCheckboxCard({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Checkbox(
            value: value,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            activeColor: const Color(0xFFFBB03B),
            onChanged: onChanged,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(description,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required Color color,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 160,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          side: borderColor != null
              ? BorderSide(color: borderColor, width: 1)
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
