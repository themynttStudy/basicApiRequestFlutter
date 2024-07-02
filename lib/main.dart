import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: const ColorScheme.dark(primary: Colors.green)),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Quanto vale 1 dolar?'),
        ),
        body: const Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _data;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    _data = "";
    try {
      isLoading = true;
      final response =
          await http.get(Uri.parse('https://economia.awesomeapi.com.br/USD/1'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        String high = data[0]['high'];
        double price = double.parse(high);
        String formatedHigh = price.toStringAsFixed(2);
        setState(() => _data = 'R\$ $formatedHigh');

        isLoading = false;
      } else {
        isLoading = false;
        throw Exception('Não foi possível carregar');
      }
    } catch (e) {
      setState(() => _data = 'Não foi possível carregar');
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: fetchData,
          child: const Icon(Icons.refresh),
        ),
        body: Center(
            child: Wrap(
          spacing: 1,
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              '1 Dolar equivale a',
              style: TextStyle(fontSize: 24),
            ),
            isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  )
                : Text(
                    _data ?? 'Carregando...',
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
          ],
        )));
  }
}
