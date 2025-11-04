import 'package:flutter/material.dart';
import 'package:hngi13_stage3_wallpaperstudio/widgets/responsive_scaffold.dart';
import 'package:hngi13_stage3_wallpaperstudio/widgets/title_desc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: "Wallpaper Studio",
      onHomePage: true,
      onBrowsePage: false,
      onFavPage: false,
      onSettingsPage: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(47, 53, 47, 118.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 50,
          children: [
            const TitleDesc(
              title: "Settings",
              description: "Customize your Wallpaper Studio experience",
            ),
            Container(
              width: double.maxFinite,
              height: 628,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 151, child: SizedBox.expand()),
                  Expanded(
                    flex: 569,
                    child: Container(
                      padding: const EdgeInsets.only(
                        // left: 151,
                        bottom: 114,
                        top: 114,
                      ),
                      child: const SetUpContent(),
                    ),
                  ),
                  const Expanded(
                    flex: 623,
                    child: Text(
                      "Phone Area",
                      style: TextStyle(color: Colors.black),
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

// ✅ Now make this stateful to manage switch state
class SetUpContent extends StatefulWidget {
  const SetUpContent({super.key});

  @override
  State<SetUpContent> createState() => _SetUpContentState();
}

class _SetUpContentState extends State<SetUpContent> {
  bool isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 399,
      child: Column(
        spacing: 26,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: const [
              Text(
                "Wallpaper Setup",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
              Text(
                "Configure your wallpaper settings and enable auto-rotation",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          // 🔽 Dropdown container
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18.5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                const Text(
                  "Image Quality",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                _dropdown(),
              ],
            ),
          ),

          // 🔽 Notification section with toggle
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18.5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: _notification(
              title: "Notification",
              text: "Get notified about new wallpapers and updates",
              isEnabled: isEnabled,
              onToggle: (value) => setState(() => isEnabled = value),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 20,
            children: [
              Container(
                width: 160,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xffF8f8f8), // light grey background
                  border: Border.all(
                    color: Color(0xffdfdfdf), // thin grey border
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(30), // rounded rectangle
                ),
                child: const Center(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              Container(
                width: 180,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBB03B), // your orange
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text(
                    "Save Settings",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
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

// 🔽 Helper Widgets
Widget _dropdown() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade300, width: 1),
      borderRadius: BorderRadius.circular(7),
    ),
    child: DropdownButtonFormField<String>(
      value: 'Option 1',
      decoration: const InputDecoration(
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Colors.black,
        size: 24,
      ),
      items: const [
        DropdownMenuItem(
          value: 'Option 1',
          child: Text(
            'High (Best Quality)',
            style: TextStyle(color: Color(0xff9c9c9c)),
          ),
        ),
        DropdownMenuItem(
          value: 'Option 2',
          child: Text('Medium', style: TextStyle(color: Color(0xff9c9c9c))),
        ),
        DropdownMenuItem(
          value: 'Option 3',
          child: Text('Low', style: TextStyle(color: Color(0xff9c9c9c))),
        ),
      ],
      onChanged: (value) {},
    ),
  );
}

Widget _notification({
  required String title,
  required String text,
  required bool isEnabled,
  required ValueChanged<bool> onToggle,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
            Text(
              text,
              style: const TextStyle(
                color: Color(0xff9c9c9c),
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      Expanded(
        flex: 1,
        child: Align(
          alignment: Alignment.topRight,
          child: Transform.scale(
            scale: 0.8,
            child: Switch(
              value: isEnabled,
              onChanged: onToggle,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFFFBB03B),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey.shade300,
            ),
          ),
        ),
      ),
    ],
  );
}
