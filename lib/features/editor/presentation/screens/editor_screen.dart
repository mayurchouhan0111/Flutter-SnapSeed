import 'dart:async';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import '../../../../core/image/edit_operation.dart';
import '../../../../core/presentation/widgets/lottie_loader.dart';
import '../providers/editor_provider.dart';
import '../widgets/curves_widget.dart';
import '../widgets/tool_picker_sheet.dart';
import '../widgets/histogram_widget.dart';

class EditorScreen extends ConsumerStatefulWidget {
  final String imagePath;
  const EditorScreen({super.key, required this.imagePath});

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  ToolType _activeTool = ToolType.none;
  double _brightness = 0.0;
  double _contrast = 0.0;
  double _saturation = 0.0;
  Timer? _debounce;
  String? _currentFilter;
  double _detailsStrength = 0.0;
  double _vignetteStrength = 0.0;
  String _brushMode = 'dodge';
  bool _showHistogram = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(editorViewModelProvider.notifier).loadImage(widget.imagePath);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editorViewModelProvider);
    final isToolActive = _activeTool != ToolType.none;

    return Scaffold(
      backgroundColor: const Color(0xFF09090b), // zinc-950
      body: Stack(
        children: [
          // 1. Canvas Layer
          Positioned.fill(
            child: Center(
              child: state.isLoading
                  ? const LottieLoader(size: 150) 
                  : state.displayBytes != null
                  ? LayoutBuilder(builder: (context, constraints) {
                final isInteractive = !(_activeTool == ToolType.brush || _activeTool == ToolType.healing);
                if (!isInteractive) {
                  return _buildBrushCanvas(context, state.displayBytes!, constraints);
                }

                return GestureDetector(
                  onLongPressStart: (_) => ref.read(editorViewModelProvider.notifier).toggleCompare(true),
                  onLongPressEnd: (_) => ref.read(editorViewModelProvider.notifier).toggleCompare(false),
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Image.memory(
                      state.displayBytes!,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              })
                  : Text(state.error ?? "No Image", style: const TextStyle(color: Color(0xFFa1a1aa))), // zinc-400
            ),
          ),

          // 2. Top Bar
          if (!isToolActive)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.auto_fix_high, color: Color(0xFFa855f7)), // Magic Purple
                            onPressed: () => _showAiSheet(context),
                          ),
                          IconButton(
                            icon: const Icon(Icons.undo, color: Color(0xFFd4d4d8)), // zinc-300
                            onPressed: () => ref.read(editorViewModelProvider.notifier).undo(),
                          ),
                          IconButton(
                            icon: const Icon(Icons.layers, color: Colors.white),
                            onPressed: () => _showHistorySheet(context),
                          ),
                          IconButton(
                            icon: Icon(Icons.bar_chart, color: _showHistogram ? const Color(0xFF6366f1) : Colors.white),
                            onPressed: () => setState(() => _showHistogram = !_showHistogram),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

          if (_showHistogram && state.histogram != null)
            Positioned(
              top: 80,
              left: 16,
              child: IgnorePointer(child: HistogramWidget(data: state.histogram!)),
            ),

          // 3. Bottom UI
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: isToolActive ? _buildActiveToolPanel() : _buildMainBottomBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMainBottomBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF18181b), // zinc-900
        border: Border(top: BorderSide(color: Color(0xFF27272a))), // zinc-800
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _BottomBarItem(
                  icon: Icons.filter_vintage,
                  label: "LOOKS",
                  onTap: () {
                    setState(() => _activeTool = ToolType.filter);
                  }),
              _BottomBarItem(icon: Icons.brush, label: "TOOLS", onTap: () => _showToolsSheet(context)),
              _BottomBarItem(icon: Icons.share, label: "EXPORT", onTap: () => _showExportSheet(context)),
            ],
          ),
        ),
      ),
    );
  }

  void _showExportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF18181b), // zinc-900
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.save_alt, color: Color(0xFF6366f1)), // indigo
              title: const Text("Save", style: TextStyle(color: Colors.white)),
              subtitle: const Text("Create a copy of your photo", style: TextStyle(color: Color(0xFF71717a))), // zinc-500
              onTap: () async {
                Navigator.pop(ctx);
                final path = await ref.read(editorViewModelProvider.notifier).exportImage();
                if (path != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Color(0xFF27272a), // zinc-800
                      content: Text('Saved to Gallery!', style: TextStyle(color: Color(0xFF4ade80))))); // green success
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Color(0xFF3b82f6)), // blue info
              title: const Text("Share", style: TextStyle(color: Colors.white)),
              onTap: () async {
                Navigator.pop(ctx);
                final path = await ref.read(editorViewModelProvider.notifier).exportImage();
                if (path != null) {
                  await Share.shareXFiles([XFile(path)], text: 'Edited with PhotoCaro');
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showToolsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF18181b),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => ToolPickerSheet(
        onToolSelected: (toolKey) {
          Navigator.pop(ctx);
          HapticFeedback.selectionClick();
          setState(() {
            _activeTool = ToolType.values.firstWhere(
                  (e) => e.toString().split('.').last == toolKey,
              orElse: () => ToolType.none,
            );
          });
        },
      ),
    );
  }

  void _showHistorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF18181b),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Consumer(
        builder: (context, ref, _) {
          final history = ref.watch(editorViewModelProvider).history;

          if (history.isEmpty) {
            return const SizedBox(height: 200, child: Center(child: Text("No edits yet", style: TextStyle(color: Colors.white54))));
          }

          return Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Edit History", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final op = history[history.length - 1 - index];
                      return ListTile(
                        leading: Icon(_getToolIcon(op.type), color: Colors.white70),
                        title: Text(op.type.toString().split('.').last.toUpperCase(), style: const TextStyle(color: Colors.white)),
                        subtitle: Text(_getOpSummary(op), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () {
                            ref.read(editorViewModelProvider.notifier).deleteOperation(op.id);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getToolIcon(ToolType type) {
    switch (type) {
      case ToolType.tune: return Icons.tune;
      case ToolType.crop: return Icons.crop;
      case ToolType.rotate: return Icons.rotate_right;
      case ToolType.filter: return Icons.style;
      case ToolType.curves: return Icons.show_chart;
      case ToolType.details: return Icons.details;
      case ToolType.vignette: return Icons.vignette;
      case ToolType.text: return Icons.text_fields;
      case ToolType.brush: return Icons.brush;
      case ToolType.healing: return Icons.healing;
      default: return Icons.edit;
    }
  }

  String _getOpSummary(EditOperation op) {
    final params = op.params;
    if (params.isEmpty) return "";
    return params.entries.take(2).map((e) => "${e.key}: ${e.value.toString().length > 10 ? '...' : e.value}").join(", ");
  }

  Widget _buildActiveToolPanel() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF18181b),
        border: Border(top: BorderSide(color: Color(0xFF27272a))),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: _buildToolControls(),
              ),
              const Divider(height: 1, color: Color(0xFF27272a)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, size: 28, color: Color(0xFFa1a1aa)),
                      onPressed: () => setState(() => _activeTool = ToolType.none),
                    ),
                    Text(_activeTool.toString().split('.').last.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
                    IconButton(
                      icon: const Icon(Icons.check, size: 28, color: Color(0xFF6366f1)), // Indigo check
                      onPressed: () => setState(() => _activeTool = ToolType.none),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrushCanvas(BuildContext context, Uint8List bytes, BoxConstraints constraints) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFF27272a))),
      child: Image.memory(bytes, fit: BoxFit.contain),
    );
  }

  Widget _buildToolControls() {
    switch (_activeTool) {
      case ToolType.tune:
        return Column(
          children: [
            _buildSlider("Brightness", _brightness, (v) {
              _brightness = v;
              _updateTune();
            }),
            _buildSlider("Contrast", _contrast, (v) {
              _contrast = v;
              _updateTune();
            }),
            _buildSlider("Saturation", _saturation, (v) {
              _saturation = v;
              _updateTune();
            }),
          ],
        );
      case ToolType.details:
        return _buildSlider("Structure", _detailsStrength, (v) {
          _detailsStrength = v;
          _updateDetails();
        });
      case ToolType.text:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Enter text...",
              hintStyle: TextStyle(color: Colors.white24),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
            ),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                ref
                    .read(editorViewModelProvider.notifier)
                    .applyEdit(EditOperation(id: 'text_${DateTime.now()}', type: ToolType.text, params: {'text': value}));
              }
            },
          ),
        );
      case ToolType.healing:
        return const Center(child: Text("Tap on blemishes to remove", style: TextStyle(color: Colors.white)));
      case ToolType.crop:
        return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _FilterButton(name: "Free", isSelected: false, onPressed: () {}),
          _FilterButton(
              name: "Square",
              isSelected: false,
              onPressed: () => ref
                  .read(editorViewModelProvider.notifier)
                  .applyEdit(EditOperation(id: 'crop_sq', type: ToolType.crop, params: {'aspectRatio': 1.0}))),
          _FilterButton(
              name: "16:9",
              isSelected: false,
              onPressed: () => ref
                  .read(editorViewModelProvider.notifier)
                  .applyEdit(EditOperation(id: 'crop_169', type: ToolType.crop, params: {'aspectRatio': 16 / 9}))),
        ]);
      case ToolType.rotate:
        return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(
            icon: const Icon(Icons.rotate_left, color: Colors.white, size: 32),
            onPressed: () => ref
                .read(editorViewModelProvider.notifier)
                .applyEdit(EditOperation(id: 'rot_-90', type: ToolType.rotate, params: {'angle': -90})),
          ),
          const SizedBox(width: 32),
          IconButton(
            icon: const Icon(Icons.rotate_right, color: Colors.white, size: 32),
            onPressed: () => ref
                .read(editorViewModelProvider.notifier)
                .applyEdit(EditOperation(id: 'rot_90', type: ToolType.rotate, params: {'angle': 90})),
          ),
        ]);
      case ToolType.curves:
        return SizedBox(
          height: 240,
          child: CurvesWidget(onCurveChanged: (points) {
            final List<Map<String, double>> serialized = points.map((p) => {'x': p.dx, 'y': p.dy}).toList();
            if (_debounce?.isActive ?? false) _debounce!.cancel();
            _debounce = Timer(const Duration(milliseconds: 150), () {
              ref.read(editorViewModelProvider.notifier).applyEdit(EditOperation(id: 'curves_tool', type: ToolType.curves, params: {'points': serialized}));
            });
          }),
        );
      case ToolType.filter:
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterButton(name: "None", isSelected: _currentFilter == null, onPressed: () => _applyFilter(null)),
              _FilterButton(name: "B&W", isSelected: _currentFilter == 'grayscale', onPressed: () => _applyFilter('grayscale')),
              _FilterButton(name: "Sepia", isSelected: _currentFilter == 'sepia', onPressed: () => _applyFilter('sepia')),
              _FilterButton(name: "Invert", isSelected: _currentFilter == 'invert', onPressed: () => _applyFilter('invert')),
            ],
          ),
        );
      case ToolType.vignette:
        return _buildSlider("Strength", _vignetteStrength, (v) {
          _vignetteStrength = v;
          _updateVignette();
        });
      case ToolType.brush:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _FilterButton(name: "Dodge", isSelected: _brushMode == 'dodge', onPressed: () => setState(() => _brushMode = 'dodge')),
            const SizedBox(width: 12),
            _FilterButton(name: "Burn", isSelected: _brushMode == 'burn', onPressed: () => setState(() => _brushMode = 'burn')),
          ],
        );
      default:
        return const Center(child: Text("Select tool parameters", style: TextStyle(color: Color(0xFF71717a))));
    }
  }

  Widget _buildSlider(String label, double value, Function(double) onChanged) {
    return Row(
      children: [
        SizedBox(width: 80, child: Text(label, style: const TextStyle(color: Color(0xFFd4d4d8), fontSize: 12))),
        Expanded(
          child: Slider(
            value: value,
            min: -100,
            max: 100,
            activeColor: const Color(0xFF6366f1),
            inactiveColor: const Color(0xFF27272a),
            onChanged: (v) => setState(() => onChanged(v)),
          ),
        ),
      ],
    );
  }

  void _applyFilter(String? name) {
    if (name == _currentFilter) return;
    setState(() => _currentFilter = name);
    ref.read(editorViewModelProvider.notifier).applyEdit(EditOperation(id: 'filter_tool', type: ToolType.filter, params: {'name': name ?? 'none'}));
  }

  void _updateTune() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 150), () {
      ref.read(editorViewModelProvider.notifier).applyEdit(EditOperation(
          id: 'tune_tool', type: ToolType.tune, params: {'brightness': _brightness, 'contrast': _contrast, 'saturation': _saturation}));
    });
  }

  void _updateVignette() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 150), () {
      ref
          .read(editorViewModelProvider.notifier)
          .applyEdit(EditOperation(id: 'vignette_tool', type: ToolType.vignette, params: {'strength': _vignetteStrength}));
    });
  }

  void _updateDetails() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 150), () {
      ref
          .read(editorViewModelProvider.notifier)
          .applyEdit(EditOperation(id: 'details_tool', type: ToolType.details, params: {'strength': _detailsStrength}));
    });
  }

  void _showAiSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF18181b),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("AI Magic Styles", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          _buildAiOption(ctx, "Auto Enhance", Icons.auto_fix_high, null),
          _buildAiOption(ctx, "Cyberpunk", Icons.nightlight_round, "cyberpunk style, neon lights, high contrast, cool colors, futuristic"),
          _buildAiOption(ctx, "Vintage", Icons.history, "vintage photo style, warm sepia tones, faded, grain, 1950s"),
          _buildAiOption(ctx, "Cinematic", Icons.movie, "cinematic movie look, dramatic lighting, moody, teal and orange color grading"),
          _buildAiOption(ctx, "HDR", Icons.hdr_on, "hdr style, vibrant colors, high dynamic range, detailed textures, sharp"),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildAiOption(BuildContext ctx, String label, IconData icon, String? prompt) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: const Color(0xFF27272a), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: const Color(0xFFa855f7)),
      ),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white24),
      onTap: () async {
        Navigator.pop(ctx);
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("Applying $label..."), duration: const Duration(seconds: 1), backgroundColor: const Color(0xFF27272a))
        );
        final success = await ref.read(editorViewModelProvider.notifier).autoEnhance(prompt: prompt);
        if (context.mounted && success) {
            ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text("✨ Magic Applied!"), backgroundColor: Colors.purpleAccent)
            );
        }
      },
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _BottomBarItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFFd4d4d8)),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Color(0xFFa1a1aa), fontSize: 10, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onPressed;
  const _FilterButton({required this.name, this.isSelected = false, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFF6366f1).withOpacity(0.1) : Colors.transparent,
          side: BorderSide(color: isSelected ? const Color(0xFF6366f1) : const Color(0xFF27272a)),
          foregroundColor: isSelected ? const Color(0xFF6366f1) : Colors.white,
        ),
        onPressed: onPressed,
        child: Text(name),
      ),
    );
  }
}