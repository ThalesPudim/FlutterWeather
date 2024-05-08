import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  bool _buttonClicked = false;
  String? _nickname;
  String? _weatherDescription;
  String? _temperature;
  String? _iconUrl;

  @override
  void initState() {
    super.initState();
    _loadNickName();
  }

  Future<void> _loadNickName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? nickname = prefs.getString('nickname');
    setState(() {
      _nickname = nickname;
    });
  }

  @override
  void dispose() {
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _getWeather() async {
    var city = _cityController.text;
    var state = _stateController.text;
    var country = _countryController.text;
    var apiKey = ""; // // Coloque sua API KEY aqui para que o código funcione -- https://openweathermap.org/api
    var url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city,$state,$country&appid=$apiKey&lang=pt_br';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        _weatherDescription = data['weather'][0]['description'];
        _temperature =
            ((data['main']['temp'] - 273.15).toStringAsFixed(1)) + "°C";
        _iconUrl =
            'http://openweathermap.org/img/w/${data['weather'][0]['icon']}.png';
        _buttonClicked = true;
      });
    } else {
      setState(() {
        _weatherDescription =
            'Erro ao obter os dados. Verifique a cidade, o estado e o país e tente novamente.';
        _buttonClicked = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de Clima'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/NewImage8K.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 200),
                if (_nickname != null)
                  Text(
                    'Bem-vindo $_nickname',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                const Text(
                  'Consultar Clima',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'Cidade',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(
                    labelText: 'Estado',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _countryController,
                  decoration: const InputDecoration(
                    labelText: 'País',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_cityController.text.isNotEmpty &&
                        _stateController.text.isNotEmpty &&
                        _countryController.text.isNotEmpty) {
                      _getWeather();
                    } else {
                      setState(() {
                        _buttonClicked = false;
                      });
                      print('Preencha todas as caixas de texto!');
                    }
                  },
                  child: const Text('Consultar'),
                ),
                const SizedBox(height: 20),
                if (_buttonClicked)
                  Column(
                    children: [
                      Text(
                        '$_weatherDescription, $_temperature',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Image.network(_iconUrl!),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
