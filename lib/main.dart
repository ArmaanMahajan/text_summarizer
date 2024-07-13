import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _currentSliderValue = 60;
  String summaryText = "Enter text to be summarized";
  String articleText = "";
  String apiKey = ''; //Todo Insert API key here

  void _handleSummarize() async {
    setState(() async {
      summaryText = await summarizeText(articleText);
    });
  }

  void _updateArticleText(String text) {
    setState(() {
      articleText = text;
    });
  }

  Future<String> summarizeText(String text) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );

    final prompt = "Summarize this article in a concise and informative way (up to $_currentSliderValue words):\n$text";
    final content = [Content.text(prompt)];

    try {
      final response = await model.generateContent(content);
      final String? summary = response.text;
      final String regularSummary = summary ?? "";
      return regularSummary;
    } catch (error) {
      return "An error occurred. Please try again later.";
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article summarizer'),
        backgroundColor: Colors.deepPurpleAccent,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24.0,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Insert article text here',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter article text',
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    onChanged: (text) => _updateArticleText(text),
                  ),
                  Slider(
                    value: _currentSliderValue,
                    max: 210,
                    min: 10,
                    divisions: 10,
                    label: _currentSliderValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                      });
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                 _handleSummarize();
                },
                child: const Icon(Icons.check),
              ),
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(summaryText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}