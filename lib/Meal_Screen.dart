// FoodImageUploadScreen.dart
// Complete updated file with rotating upload messages (no emojis),
// changes message every 4 seconds while uploading.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class FoodImageUploadScreen extends StatefulWidget {
  const FoodImageUploadScreen({Key? key}) : super(key: key);

  @override
  State<FoodImageUploadScreen> createState() => _FoodImageUploadScreenState();
}

class _FoodImageUploadScreenState extends State<FoodImageUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isUploading = false;
  String? _error;

  String? foodName;
  int? calories;
  double? protein;
  double? carbs;
  double? fat;

  final Color _nutriGreen = const Color(0xFF6ABF4B);
  final String uploadUrl = 'https://nutritrack-backend-lghm.onrender.com/api/upload-image';

  // Rotating messages (no emojis)
  final List<String> funMessages = [
    "Your food looks so yummy our system paused to drool…",
    "Hold on… our AI chef is taking a bite first",
    "Wow! That dish distracted our system for a second",
    "Processing… your food's deliciousness is overwhelming",
    "Just a moment… our AI is daydreaming about your food",
    "Your food is causing a mini hunger strike inside the server",
  ];

  int _currentMessageIndex = 0;
  Timer? _messageTimer;

  @override
  void dispose() {
    _messageTimer?.cancel();
    super.dispose();
  }

  void _showSnackBar(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? _nutriGreen : Colors.redAccent,
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    setState(() => _error = null);
    try {
      final picked = await _picker.pickImage(source: source, maxWidth: 1600, maxHeight: 1600, imageQuality: 85);
      if (picked == null) return;
      setState(() => _selectedImage = File(picked.path));
    } catch (e) {
      setState(() => _error = 'Failed to pick image: $e');
    }
  }

  void _startMessageRotation() {
    _messageTimer?.cancel();
    _currentMessageIndex = 0;
    setState(() {
      _error = funMessages[_currentMessageIndex];
    });
    _messageTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        _currentMessageIndex = (_currentMessageIndex + 1) % funMessages.length;
        _error = funMessages[_currentMessageIndex];
      });
    });
  }

  void _stopMessageRotation() {
    _messageTimer?.cancel();
    _messageTimer = null;
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isUploading = true;
      // clear previous results
      foodName = null;
      calories = null;
      protein = null;
      carbs = null;
      fat = null;
    });

    // start rotating friendly messages
    _startMessageRotation();

    try {
      final file = _selectedImage!;
      final fileBytes = await file.readAsBytes();
      final fileLen = fileBytes.length;
      final fileName = file.path.split(Platform.pathSeparator).last;
      final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
      final mimeParts = mimeType.split('/');
      final contentType = MediaType(mimeParts[0], mimeParts.length > 1 ? mimeParts[1] : 'jpeg');

      final uri = Uri.parse(uploadUrl);
      final request = http.MultipartRequest('POST', uri);

      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: fileName.isNotEmpty ? fileName : 'file.jpg',
        contentType: contentType,
      );

      request.files.add(multipartFile);
      request.headers['Accept'] = 'text/event-stream, application/json, text/plain, */*';

      final streamedResp = await request.send().timeout(const Duration(seconds: 90));
      final respStr = await streamedResp.stream.bytesToString();

      if (streamedResp.statusCode < 200 || streamedResp.statusCode >= 300) {
        _stopMessageRotation();
        setState(() {
          _error = 'Server returned status ${streamedResp.statusCode}:\n$respStr';
        });
        return;
      }

      dynamic decoded;
      // 1) try direct JSON
      try {
        decoded = jsonDecode(respStr);
      } catch (e) {
        // 2) try SSE parser / fallback
        try {
          decoded = _parseSseResponse(respStr);
        } catch (e2) {
          // 3) last attempt: try to extract JSON substring
          try {
            final regex = RegExp(r'(\[.*\]|\{.*\})', dotAll: true);
            final match = regex.firstMatch(respStr);
            if (match != null) {
              final candidate = match.group(0)!;
              decoded = jsonDecode(candidate);
            } else {
              throw Exception('No JSON-like substring found');
            }
          } catch (e3) {
            _stopMessageRotation();
            setState(() => _error = 'Failed to parse server response:\n1) jsonDecode: $e\n2) sseParse: $e2\n3) substringParse: $e3\n\nRaw response:\n$respStr');
            return;
          }
        }
      }

      // parsing succeeded — stop rotating messages and clear the message box
      _stopMessageRotation();
      setState(() => _error = null);

      // hand off parsed data for UI update
      _parseResponse(decoded);

      _showSnackBar('Analysis completed', success: true);
    } catch (e) {
      _stopMessageRotation();
      setState(() => _error = 'Upload failed: $e');
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  dynamic _parseSseResponse(String raw) {
    // Try collecting data: lines first
    final lines = raw.split(RegExp(r'\r?\n'));
    final dataLines = <String>[];
    for (var line in lines) {
      line = line.trim();
      if (line.startsWith('data:')) dataLines.add(line.substring(5).trim());
    }

    if (dataLines.isNotEmpty) {
      final joined = dataLines.join('\n').trim();
      if (joined.startsWith('{') || joined.startsWith('[')) {
        return jsonDecode(joined);
      }
    }

    // fallback: try to locate a JSON substring anywhere in the raw text
    final regex = RegExp(r'(\[.*\]|\{.*\})', dotAll: true);
    final match = regex.firstMatch(raw);
    if (match != null) {
      final candidate = match.group(0)!.trim();
      try {
        return jsonDecode(candidate);
      } catch (e) {
        throw FormatException('Found JSON-like substring but jsonDecode failed: $e\n$candidate');
      }
    }

    // last-ditch: search for any line that looks like JSON and decode it
    for (var line in lines.reversed) {
      final t = line.trim();
      if (t.startsWith('[') || t.startsWith('{')) {
        try {
          return jsonDecode(t);
        } catch (_) {
          // continue trying
        }
      }
    }

    throw FormatException('No JSON content found in SSE response');
  }

  void _parseResponse(dynamic decoded) {
    try {
      // Helper: recursively find a Map with predicted_label
      Map<String, dynamic>? findPrediction(dynamic node) {
        if (node == null) return null;

        if (node is Map) {
          if (node.containsKey('predicted_label')) {
            return Map<String, dynamic>.from(node);
          }
          for (final key in ['prediction', 'predictions', 'data', 'result', 'results']) {
            if (node.containsKey(key)) {
              final val = node[key];
              final fromChild = findPrediction(val);
              if (fromChild != null) return fromChild;
            }
          }
          for (final v in node.values) {
            final res = findPrediction(v);
            if (res != null) return res;
          }
        }

        if (node is List) {
          for (final el in node) {
            if (el is Map && el.containsKey('predicted_label')) {
              return Map<String, dynamic>.from(el);
            }
          }
          for (final el in node) {
            final res = findPrediction(el);
            if (res != null) return res;
          }
        }

        return null;
      }

      if (decoded is String) {
        try {
          decoded = jsonDecode(decoded);
        } catch (_) {
          // keep string
        }
      }

      final predictionMap = findPrediction(decoded);

      if (predictionMap != null) {
        _applyPredictionMap(predictionMap);
        return;
      }

      // If decoded is a List with descriptive strings like your backend returned
      if (decoded is List) {
        for (final element in decoded) {
          if (element is String) {
            final parsed = _parseFromDescriptiveString(element);
            if (parsed != null) {
              setState(() {
                foodName = parsed['name'];
                calories = parsed['calories'];
                protein = parsed['protein'] != null ? parsed['protein']!.toDouble() : null;
                carbs = parsed['carbs'] != null ? parsed['carbs']!.toDouble() : null;
                fat = parsed['fat'] != null ? parsed['fat']!.toDouble() : null;
              });
              return;
            }
          }
          if (element is List) {
            for (final sub in element) {
              if (sub is String) {
                final parsed = _parseFromDescriptiveString(sub);
                if (parsed != null) {
                  setState(() {
                    foodName = parsed['name'];
                    calories = parsed['calories'];
                    protein = parsed['protein'] != null ? parsed['protein']!.toDouble() : null;
                    carbs = parsed['carbs'] != null ? parsed['carbs']!.toDouble() : null;
                    fat = parsed['fat'] != null ? parsed['fat']!.toDouble() : null;
                  });
                  return;
                }
              }
            }
          }
        }
      }

      // Map with 'prediction' list fallback
      if (decoded is Map && decoded['prediction'] is List) {
        final list = decoded['prediction'] as List;
        for (final element in list) {
          if (element is Map && element.containsKey('predicted_label')) {
            _applyPredictionMap(Map<String, dynamic>.from(element));
            return;
          }
        }
      }

      final preview = decoded != null ? decoded.toString().replaceAll(RegExp(r'\s+'), ' ').substring(0, decoded.toString().length.clamp(0, 600)) : 'null';
      setState(() => _error = 'Could not parse server response structure\nType: ${decoded.runtimeType}\nPreview: $preview');
    } catch (e, st) {
      setState(() => _error = 'Parsing error: $e\n$st');
    }
  }

  void _applyPredictionMap(Map element) {
    setState(() {
      foodName = element['predicted_label']?.toString();
      final nut = element['nutrition'];
      if (nut is Map) {
        // calories may be int/double/string
        if (nut['calories'] != null) {
          final c = nut['calories'];
          if (c is int) {
            calories = c;
          } else if (c is double) {
            calories = c.toInt();
          } else if (c is String) {
            calories = int.tryParse(c) ?? (double.tryParse(c)?.toInt());
          } else {
            calories = null;
          }
        } else {
          calories = null;
        }

        protein = nut['protein'] != null ? (nut['protein'] as num).toDouble() : null;
        carbs = nut['carbs'] != null ? (nut['carbs'] as num).toDouble() : null;
        fat = nut['fat'] != null ? (nut['fat'] as num).toDouble() : null;
      } else {
        calories = null;
        protein = null;
        carbs = null;
        fat = null;
      }
    });
  }

  Map<String, dynamic>? _parseFromDescriptiveString(String s) {
    try {
      final nameMatch = RegExp(r'^([^—\(\-]+?)').firstMatch(s);
      String? name = nameMatch?.group(0)?.trim();
      final kcalMatch = RegExp(r'(\d{2,5})\s*kcal', caseSensitive: false).firstMatch(s);
      final pMatch = RegExp(r'P[:]?\s*(\d+\.?\d*)g', caseSensitive: false).firstMatch(s);
      final cMatch = RegExp(r'C[:]?\s*(\d+\.?\d*)g', caseSensitive: false).firstMatch(s);
      final fMatch = RegExp(r'F[:]?\s*(\d+\.?\d*)g', caseSensitive: false).firstMatch(s);

      return {
        'name': name ?? s,
        'calories': kcalMatch != null ? int.tryParse(kcalMatch.group(1)!) : null,
        'protein': pMatch != null ? double.tryParse(pMatch.group(1)!) : null,
        'carbs': cMatch != null ? double.tryParse(cMatch.group(1)!) : null,
        'fat': fMatch != null ? double.tryParse(fMatch.group(1)!) : null,
      };
    } catch (_) {
      return null;
    }
  }

  Widget _nutrientInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.9))),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 14, color: Colors.white)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = _nutriGreen;
    final hintStyle = TextStyle(color: Colors.white.withOpacity(0.7));

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('NutriTrack', style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.grey.withOpacity(0.1),
                ),
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade700),
                        color: Colors.grey.shade800,
                      ),
                      child: const Icon(Icons.fastfood, size: 32, color: Colors.white70),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Food analyzer', style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.95))),
                          const SizedBox(height: 6),
                          Text('Upload an image and get nutrition details', style: hintStyle),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade800,
                          border: Border.all(color: Colors.grey.shade700),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _selectedImage != null
                              ? GestureDetector(
                            onTap: () => _pickImage(ImageSource.gallery),
                            child: Image.file(_selectedImage!, fit: BoxFit.cover, width: double.infinity),
                          )
                              : Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.image, size: 56, color: Colors.white24),
                                const SizedBox(height: 8),
                                Text('No image selected', style: hintStyle),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _pickImage(ImageSource.gallery),
                              icon: const Icon(Icons.photo_library, color: Colors.white70),
                              label: Text('Choose from gallery', style: TextStyle(color: Colors.white.withOpacity(0.9))),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: BorderSide(color: Colors.grey.shade700),
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _pickImage(ImageSource.camera),
                              icon: const Icon(Icons.camera_alt, color: Colors.white),
                              label: Text('Use camera', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _selectedImage != null && !_isUploading ? _uploadImage : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _isUploading
                              ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : Text('Upload image', style: TextStyle(color: Colors.white)),
                        ),
                      ),

                      const SizedBox(height: 18),

                      if (_error != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red.shade50),
                          child: SelectableText(_error!, style: const TextStyle(color: Colors.red)),
                        ),
                        const SizedBox(height: 12),
                      ],

                      if (foodName != null) ...[
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.withOpacity(0.1),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(foodName!, style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.95))),
                              const SizedBox(height: 12),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                _nutrientInfo('Calories', calories != null ? '${calories} kcal' : '—'),
                                _nutrientInfo('Protein', protein != null ? '${protein!.toStringAsFixed(1)} g' : '—'),
                              ]),
                              const SizedBox(height: 10),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                _nutrientInfo('Carbs', carbs != null ? '${carbs!.toStringAsFixed(1)} g' : '—'),
                                _nutrientInfo('Fat', fat != null ? '${fat!.toStringAsFixed(1)} g' : '—'),
                              ]),
                              const SizedBox(height: 12),
                              Text('Tip: Tap the image to reselect or upload a different photo', style: hintStyle),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
