import 'dart:io';
import 'dart:typed_data';
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
  final double? height;
  final double? width;
  const SmartCacheImage({
    super.key,
    required this.url,
    this.cacheDuration = const Duration(days: 7),
    this.fit = BoxFit.cover,
    this.errorWidget,
     this.height,
     this.width,
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
    Widget child;
    if (isLoading) {
      child = Center(
        child: SizedBox(
            height: 40,
            width: 40,
            child: const CircularProgressIndicator()),
      );
    } else if (hasError || currentFile == null) {
      child =
          widget.errorWidget ??
          const Icon(Icons.broken_image, color: Colors.red);
    } else {
      child = Image.file(currentFile!, fit: widget.fit);
    }

    return SizedBox(height: widget.height, width: widget.width, child: child);
  }
}



class SmartCacheImageV3 extends StatefulWidget {
  final String url;
  const SmartCacheImageV3({super.key, required this.url});

  @override
  State<SmartCacheImageV3> createState() => _SmartCacheImageV3State();
}

class _SmartCacheImageV3State extends State<SmartCacheImageV3> {
  Uint8List? _imageBytes;
  bool _isLoading = true;
  bool _hasError = false;

  // ⚡ آخری دکھائی گئی تصویر memory میں رکھو تاکہ rebuild پر blink نہ ہو
  static final Map<String, Uint8List> _memoryCache = {};

  @override
  void initState() {
    super.initState();
    _loadCachedImage();
  }

  Future<void> _loadCachedImage() async {
    try {
      // اگر پہلے سے memory میں ہے → فوراً دکھاؤ
      if (_memoryCache.containsKey(widget.url)) {
        _imageBytes = _memoryCache[widget.url];
        _isLoading = false;
        setState(() {});
        return;
      }

      final file = await _getCachedFile(widget.url);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        _memoryCache[widget.url] = bytes;
        if (!mounted) return;
        setState(() {
          _imageBytes = bytes;
          _isLoading = false;
        });
      } else {
        final response = await http.get(Uri.parse(widget.url));
        if (response.statusCode == 200) {
          await file.writeAsBytes(response.bodyBytes);
          _memoryCache[widget.url] = response.bodyBytes;
          if (!mounted) return;
          setState(() {
            _imageBytes = response.bodyBytes;
            _isLoading = false;
          });
        } else {
          throw Exception("Failed to load image");
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<File> _getCachedFile(String url) async {
    final dir = await getTemporaryDirectory();
    final fileName = url.hashCode.toString();
    return File('${dir.path}/$fileName.jpg');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _imageBytes == null) {
      // Placeholder bilkul CachedNetworkImage jaisa
      return Container(
        color: Colors.grey.shade200,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_hasError || _imageBytes == null) {
      // Error image
      return Container(
        color: Colors.grey.shade300,
        child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
      );
    }

    return Image.memory(
      _imageBytes!,
      fit: BoxFit.cover,
      width: double.infinity,
      height: 200, // default height (optional)
    );
  }
}
