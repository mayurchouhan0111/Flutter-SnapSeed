import 'package:flutter/material.dart';

class ToolPickerSheet extends StatelessWidget {
  final Function(String) onToolSelected;

  const ToolPickerSheet({required this.onToolSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 48),
      decoration: const BoxDecoration(
        color: Color(0xFF18181b),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: Color(0xFF27272a)))
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
               width: 40, height: 4, 
               margin: const EdgeInsets.only(bottom: 24),
               decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))
            ),
            GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 24,
                crossAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _ToolItem(icon: Icons.tune, label: "Tune", onTap: () => onToolSelected('tune')),
                  _ToolItem(icon: Icons.filter_vintage, label: "Looks", onTap: () => onToolSelected('filter')),
                  _ToolItem(icon: Icons.crop, label: "Crop", onTap: () => onToolSelected('crop')),
                  _ToolItem(icon: Icons.rotate_right, label: "Rotate", onTap: () => onToolSelected('rotate')),
                  _ToolItem(icon: Icons.show_chart, label: "Curves", onTap: () => onToolSelected('curves')), 
                  _ToolItem(icon: Icons.details, label: "Details", onTap: () => onToolSelected('details')), 
                  _ToolItem(icon: Icons.vignette, label: "Vignette", onTap: () => onToolSelected('vignette')), 
                  _ToolItem(icon: Icons.brush, label: "Brush", onTap: () => onToolSelected('brush')), 
                  _ToolItem(icon: Icons.healing, label: "Healing", onTap: () => onToolSelected('healing')), 
                  _ToolItem(icon: Icons.text_fields, label: "Text", onTap: () => onToolSelected('text')), 
                ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ToolItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
             padding: const EdgeInsets.all(12),
             decoration: BoxDecoration(
                color: const Color(0xFF27272a), // zinc-800
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white10)
             ),
             child: Icon(icon, size: 24, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(label, 
              style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500), 
              textAlign: TextAlign.center,
              maxLines: 1, overflow: TextOverflow.ellipsis
          ),
        ],
      ),
    );
  }
}
