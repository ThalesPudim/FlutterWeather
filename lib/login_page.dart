import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'weather_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/NewImage8K.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Por favor, insira um email válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.length < 4) {
                    return 'A senha deve ter pelo menos 4 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _authenticateUser(
                      context, _emailController.text, _passwordController.text);
                },
                child: const Text('Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _authenticateUser(
      BuildContext context, String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? storedEmail = prefs.getString('email');
    final String? storedPassword = prefs.getString('password');

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira email e senha')),
      );
      return;
    }

    // Verifique se o e-mail inserido pelo usuário corresponde ao e-mail armazenado
    // e se a senha inserida pelo usuário corresponde à senha armazenada
    if (email == storedEmail && password == storedPassword) {
      // Autenticação bem-sucedida, navegue para a próxima tela
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WeatherPage()),
      );
    } else {
      // Autenticação falhou, exiba uma mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciais inválidas')),
      );
    }
  }
}
