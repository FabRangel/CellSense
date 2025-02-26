import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter_pytorch/flutter_pytorch.dart';
import 'package:flutter_pytorch/pigeon.dart';
import 'package:cellsense/widgets/loader_state.dart';

class ResultScreen extends StatefulWidget {
  final File image;

  const ResultScreen({required this.image, super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late Future<void> _modelFuture;
  late ModelObjectDetection _objectModel;
  List<ResultObjectDetection?> objDetect = [];
  String? selectedModel;
  String detectionResults = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadModel(String modelPath, String labelPath) async {
    try {
      _objectModel = await FlutterPytorch.loadObjectDetectionModel(
          modelPath, 16, 640, 640,
          labelPath: labelPath);
      await runObjectDetection();
    } catch (e) {
      if (e is PlatformException) {
        print("only supported for android, Error is $e");
      } else {
        print("Error is $e");
      }
    }
  }

  Future<void> runObjectDetection() async {
    objDetect = await _objectModel.getImagePrediction(
        await widget.image.readAsBytes(),
        minimumScore: 0.1,
        IOUThershold: 0.3);
    StringBuffer resultsBuffer = StringBuffer();
    objDetect.forEach((element) {
      resultsBuffer.writeln({
        "score": element?.score,
        "className": element?.className,
        "class": element?.classIndex,
        "rect": {
          "left": element?.rect.left,
          "top": element?.rect.top,
          "width": element?.rect.width,
          "height": element?.rect.height,
          "right": element?.rect.right,
          "bottom": element?.rect.bottom,
        },
      });
    });
    setState(() {
      detectionResults = resultsBuffer.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Resultados")),
      body: selectedModel == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedModel = "yolov5s";
                        _modelFuture = loadModel(
                          "assets/models/yolov5s.torchscript",
                          "assets/labels/labels.txt",
                        );
                      });
                    },
                    child: const Text("Usar YOLOv5s"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print("Usar Best Model");
                      setState(() {
                        selectedModel = "best";
                        _modelFuture = loadModel(
                          "assets/models/best.pt",
                          "assets/labels/labels2.txt",
                        );
                      });
                    },
                    child: const Text("Usar Best Model"),
                  ),
                ],
              ),
            )
          : FutureBuilder<void>(
              future: _modelFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoaderState();
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 400,
                          child: _objectModel.renderBoxesOnImage(
                              widget.image, objDetect),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          color: Colors.grey[200],
                          child: SingleChildScrollView(
                            child: Text(
                              detectionResults,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
    );
  }
}