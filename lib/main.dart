import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BmiCalculate(),
    );
  }
}


class BmiCalculate extends StatefulWidget {
  const BmiCalculate({super.key});

  @override
  State<BmiCalculate> createState() => _BmiCalculateState();
}

class _BmiCalculateState extends State<BmiCalculate> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _feetController = TextEditingController();
  final TextEditingController _inchController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  String _finalResult = "";
  double _bmiValue = 0.0; // Store BMI for gauge

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  hintText: 'Enter your age',
                  icon: Icon(Icons.person),
                ),
              ),
              TextFormField(
                controller: _feetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Height (feet)',
                  hintText: 'Enter your height in feet',
                  icon: Icon(Icons.height_outlined),
                ),
              ),
              TextFormField(
                controller: _inchController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Height (inch)',
                  hintText: 'Enter your height in inches',
                  icon: Icon(Icons.height),
                ),
              ),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  hintText: 'Enter your current weight',
                  icon: Icon(Icons.monitor_weight),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: bmiCalculate,
                child: const Text('Calculate BMI'),
              ),
              const SizedBox(height: 20),
              Text(
                _finalResult,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                width: 300,
                child: SfRadialGauge(
                  title: const GaugeTitle(
                    text: 'BMI Gauge',
                    textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: 10,
                      maximum: 40, // BMI range
                      ranges: <GaugeRange>[
                        GaugeRange(
                          startValue: 10,
                          endValue: 18.5,
                          color: Colors.blue,
                          startWidth: 10,
                          endWidth: 10,
                        ),
                        GaugeRange(
                          startValue: 18.5,
                          endValue: 24.9,
                          color: Colors.green,
                          startWidth: 10,
                          endWidth: 10,
                        ),
                        GaugeRange(
                          startValue: 25,
                          endValue: 29.9,
                          color: Colors.orange,
                          startWidth: 10,
                          endWidth: 10,
                        ),
                        GaugeRange(
                          startValue: 30,
                          endValue: 40,
                          color: Colors.red,
                          startWidth: 10,
                          endWidth: 10,
                        ),
                      ],
                      pointers: <GaugePointer>[
                        NeedlePointer(value: _bmiValue),
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                          widget: Text(
                            _bmiValue.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          angle: 90,
                          positionFactor: 0.5,
                        ),
                      ],
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

  void bmiCalculate() {
    double age = double.tryParse(_ageController.text) ?? 0;
    double feet = double.tryParse(_feetController.text) ?? 0;
    double inch = double.tryParse(_inchController.text) ?? 0;
    double weight = double.tryParse(_weightController.text) ?? 0;

    if (age < 5 || age > 120) {
      setState(() {
        _finalResult = "Please enter age between 5 and 120 years.";
        _bmiValue = 0.0;
      });
      return;
    }

    double heightInMeters = (feet * 12 + inch) * 0.0254;
    if (heightInMeters <= 0 || weight <= 0) {
      setState(() {
        _finalResult = "Please enter valid height and weight values.";
        _bmiValue = 0.0;
      });
      return;
    }

    double bmi = weight / (heightInMeters * heightInMeters);
    String category = bmi < 18.5
        ? "Underweight"
        : bmi < 24.9
        ? "Normal weight"
        : bmi < 29.9
        ? "Overweight"
        : "Obese";

    setState(() {
      _finalResult = "BMI: ${bmi.toStringAsFixed(2)}\nCategory: $category";
      _bmiValue = bmi;
    });
  }
}