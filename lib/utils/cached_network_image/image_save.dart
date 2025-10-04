import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class SaveImage {
  Future<File> _getImageFile(String url, Duration cachedDuration) async {
    final dir = await getTemporaryDirectory();
    final fileName = url.hashCode.toString();
    final file = File('${dir.path}/$fileName');

    if (await file.exists()) {
      final lastModified = await file.lastModified();
      final currentTime = DateTime.now();
      if (currentTime.difference(lastModified) < cachedDuration) {
        return file;
        //return cached file
      }
    }
    // expire or missing file, download again
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } else {
      throw Exception('Failed to load image');
    }
  }
}

class SmartCacheImage extends StatefulWidget {
  final String url;
  final Duration cacheDuration;
  final BoxFit fit;
  final Widget? errorWidget;
  const SmartCacheImage({
    super.key,
    required this.url,
    this.cacheDuration = const Duration(days: 7),
    this.fit = BoxFit.cover,
    this.errorWidget,
  });

  @override
  State<SmartCacheImage> createState() => _SmartCacheImageState();
}

class _SmartCacheImageState extends State<SmartCacheImage> {
  File? currentFile;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      final file = await SaveImage()._getImageFile(
        widget.url,
        widget.cacheDuration,
      );
      setState(() {
        currentFile = file;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CircularProgressIndicator();
    }
    if (hasError || currentFile == null) {
      return widget.errorWidget ??
          const Icon(Icons.broken_image, color: Colors.red);
    }
    return Image.file(currentFile!, fit: widget.fit);
  }
}
