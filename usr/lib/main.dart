import 'package:flutter/material.dart';

void main() {
  runApp(const WallpaperApp());
}

class WallpaperApp extends StatelessWidget {
  const WallpaperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallpaper Creator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const WallpaperHomePage(),
    );
  }
}

class WallpaperHomePage extends StatefulWidget {
  const WallpaperHomePage({super.key});

  @override
  State<WallpaperHomePage> createState() => _WallpaperHomePageState();
}

class _WallpaperHomePageState extends State<WallpaperHomePage> {
  Color _startColor = Colors.blue;
  Color _endColor = Colors.purple;

  void _changeStartColor(Color color) {
    setState(() {
      _startColor = color;
    });
  }

  void _changeEndColor(Color color) {
    setState(() {
      _endColor = color;
    });
  }

  void _randomizeColors() {
    setState(() {
      _startColor = Color.fromRGBO(
        (0 + (255 - 0) * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000).toInt(),
        (0 + (255 - 0) * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000).toInt(),
        (0 + (255 - 0) * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000).toInt(),
        1,
      );
      _endColor = Color.fromRGBO(
        (0 + (255 - 0) * ((DateTime.now().millisecondsSinceEpoch + 500) % 1000) / 1000).toInt(),
        (0 + (255 - 0) * ((DateTime.now().millisecondsSinceEpoch + 500) % 1000) / 1000).toInt(),
        (0 + (255 - 0) * ((DateTime.now().millisecondsSinceEpoch + 500) % 1000) / 1000).toInt(),
        1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallpaper Creator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_startColor, _endColor],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _showColorPicker(context, _startColor, _changeStartColor),
                        child: const Text('Start Color'),
                      ),
                      ElevatedButton(
                        onPressed: () => _showColorPicker(context, _endColor, _changeEndColor),
                        child: const Text('End Color'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _randomizeColors,
                    child: const Text('Randomize'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(BuildContext context, Color initialColor, Function(Color) onColorChanged) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: initialColor,
              onColorChanged: onColorChanged,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ColorPicker extends StatefulWidget {
  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPicker({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
  });

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late Color currentColor;

  @override
  void initState() {
    super.initState();
    currentColor = widget.pickerColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Selected Color: ${currentColor.toString()}'),
        const SizedBox(height: 20),
        Wrap(
          children: [
            for (var color in [Colors.red, Colors.green, Colors.blue, Colors.yellow, Colors.purple, Colors.orange])
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentColor = color;
                  });
                  widget.onColorChanged(color);
                },
                child: Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}