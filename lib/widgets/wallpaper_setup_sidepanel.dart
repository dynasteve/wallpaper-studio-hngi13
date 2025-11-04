import 'package:flutter/material.dart';

class WallpaperSetupSidePanel extends StatefulWidget {
  const WallpaperSetupSidePanel({super.key});

  @override
  State<WallpaperSetupSidePanel> createState() =>
      _WallpaperSetupSidePanelState();
}

class _WallpaperSetupSidePanelState extends State<WallpaperSetupSidePanel> {
  bool isActivated = false;
  bool autoRotation = false;
  String displayMode = 'Fit';
  bool lockWallpaper = false;
  bool syncAcrossDevices = false;

  static const _panelRadius = 20.0;
  static const _accent = Color(0xFFFBB03B);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 15),
            child: Column(
              children: [
                // Header
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Wallpaper Setup",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Configure your wallpaper settings and enable auto-rotation",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // --- Activate Wallpaper ---
                        _buildRowCard(
                          childLeft: _buildCardText(
                            title: "Activate Wallpaper",
                            subtitle:
                                "Set the selected wallpaper as your desktop background",
                          ),
                          childRight: _activatePill(),
                        ),
                        const SizedBox(height: 12),

                        // --- Display Mode (NO enclosing rounded container) ---
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Display Mode",
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildRadioOption(
                          title: "Fit",
                          description: "Scale to fit without cropping",
                          value: "Fit",
                        ),
                        const SizedBox(height: 8),
                        _buildRadioOption(
                          title: "Fill",
                          description: "Scale to fill the entire screen",
                          value: "Fill",
                        ),
                        const SizedBox(height: 8),
                        _buildRadioOption(
                          title: "Stretch",
                          description: "Stretch to fill the screen",
                          value: "Stretch",
                        ),
                        const SizedBox(height: 8),
                        _buildRadioOption(
                          title: "Tile",
                          description: "Repeat the image to fill the screen",
                          value: "Tile",
                        ),

                        const SizedBox(height: 16),

                        // --- Auto-Rotation ---
                        _buildRowCard(
                          childLeft: _buildCardText(
                            title: "Auto-Rotation",
                            subtitle:
                                "Automatically change your wallpaper at regular intervals",
                          ),
                          childRight: _buildAutoRotationSwitch(),
                        ),
                        const SizedBox(height: 16),

                        // --- Advanced Settings ---
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Advanced settings",
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildCheckboxCard(
                          title: "Lock Wallpaper",
                          description: "Prevent accidental changes",
                          value: lockWallpaper,
                          onChanged: (v) =>
                              setState(() => lockWallpaper = v ?? false),
                        ),
                        const SizedBox(height: 8),
                        _buildCheckboxCard(
                          title: "Sync Across Devices",
                          description: "Keep wallpaper consistent on all devices",
                          value: syncAcrossDevices,
                          onChanged: (v) =>
                              setState(() => syncAcrossDevices = v ?? false),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // Buttons aligned right
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _actionButton(
                      label: "Cancel",
                      backgroundColor: const Color(0xFFF8F8F8),
                      textColor: Colors.black,
                      borderColor: const Color(0xFFDFDFDF),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(width: 12),
                    _actionButton(
                      label: "Save settings",
                      backgroundColor: _accent,
                      textColor: Colors.white,
                      onPressed: () => Navigator.of(context).maybePop(),
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

  Widget _actionButton({
    required String label,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      height: 46,
      width: 160,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          side: borderColor != null
              ? BorderSide(color: borderColor, width: 1)
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: textColor,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildRowCard({
    required Widget childLeft,
    required Widget childRight,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_panelRadius),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: childLeft),
          const SizedBox(width: 12),
          childRight,
        ],
      ),
    );
  }

  Widget _buildCardText({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 2),
        SizedBox(
          width: 250,
          child: Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  Widget _activatePill() {
    return GestureDetector(
      onTap: () => setState(() => isActivated = !isActivated),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActivated ? Colors.green.shade50 : Colors.white,
          border: Border.all(
            color:
                isActivated ? Colors.green.shade200 : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActivated ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isActivated ? Colors.green.shade700 : Colors.grey,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              isActivated ? "Activated" : "Activate",
              style: TextStyle(
                fontFamily: 'Poppins',
                color:
                    isActivated ? Colors.green.shade700 : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutoRotationSwitch() {
    return Switch.adaptive(
      value: autoRotation,
      onChanged: (v) => setState(() => autoRotation = v),
      activeThumbColor: _accent,
    );
  }

  Widget _buildRadioOption({
    required String title,
    required String description,
    required String value,
  }) {
    final selected = displayMode == value;
    return GestureDetector(
      onTap: () => setState(() => displayMode = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.grey.shade50 : Colors.white,
          border: Border.all(
            color: selected ? _accent : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: displayMode,
              onChanged: (v) => setState(() => displayMode = v!),
              activeColor: _accent,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.black87 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: Colors.black54,
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

  Widget _buildCheckboxCard({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_panelRadius),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            activeColor: _accent,
            side: MaterialStateBorderSide.resolveWith(
              (states) => BorderSide(color: Colors.grey.shade400),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
