import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<FileSystemEntity> _recentEdits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecents();
  }

  Future<void> _loadRecents() async {
    setState(() => _isLoading = true);
    try {
      final directory = await getApplicationDocumentsDirectory();
      final List<FileSystemEntity> files = directory.listSync().where((file) {
        final path = file.path.toLowerCase();
        return path.contains('_edited') &&
            (path.endsWith('.jpg') || path.endsWith('.png') || path.endsWith('.jpeg'));
      }).toList();

      files.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));

      setState(() {
        _recentEdits = files;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading recent edits: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    HapticFeedback.mediumImpact();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (image != null && context.mounted) {
      await context.push('/editor', extra: image.path);
      _loadRecents();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090b), // Zinc-950
      body: Stack(
        children: [
          // --- SINGLE UNIFORM BACKGROUND LAYER ---
          Positioned.fill(
            child: Opacity(
              opacity: 0.35,
              child: Lottie.asset(
                'assets/animations/Background.json',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          ),

          // --- UI CONTENT LAYER ---
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // --- SIMPLE HEADER REPLACING APP BAR ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Studio",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 32,
                          letterSpacing: -1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Your recent creations",
                        style: TextStyle(
                          color: const Color(0xFFa1a1aa), // Zinc-400
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (_isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF6366f1)),
                  ),
                )
              else if (_recentEdits.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                          (ctx, index) => _buildProjectCard(_recentEdits[index]),
                      childCount: _recentEdits.length,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 18,
                      crossAxisSpacing: 18,
                      childAspectRatio: 0.78,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _pickImage(context),
        backgroundColor: const Color(0xFF6366f1), // Indigo primary
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        icon: const Icon(Icons.add_photo_alternate_outlined, size: 24),
        label: const Text(
          "NEW PROJECT",
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.8),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF6366f1).withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_awesome_mosaic_outlined,
              size: 64,
              color: const Color(0xFF6366f1).withOpacity(0.2),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Studio is Silent",
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          const Text(
            "Start your next masterpiece now",
            style: TextStyle(color: Color(0xFF71717a), fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(FileSystemEntity file) {
    final stats = file.statSync();
    final dt = stats.modified;
    final dateStr = "${dt.day} ${_getMonth(dt.month)}";
    final fileName = file.uri.pathSegments.last.replaceAll('_edited', '').split('.').first;

    return GestureDetector(
      onTap: () => context.push('/editor', extra: file.path),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: const Color(0xFF18181b), // Zinc-900
          border: Border.all(color: const Color(0xFF27272a)), // Zinc-800
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            children: [
              Positioned.fill(
                child: Hero(
                  tag: file.path,
                  child: Image.file(File(file.path), fit: BoxFit.cover),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 14, right: 14, bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(dateStr, style: const TextStyle(color: Color(0xFFa1a1aa), fontSize: 10)),
                  ],
                ),
              ),
              Positioned(
                top: 12, right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3b82f6), // Info Blue
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "EDITED",
                    style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonth(int m) {
    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return months[m - 1];
  }
}