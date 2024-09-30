import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App con Tabs y HTTP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    PersonalInfoScreen(), // Datos personales y botones
    ApiScreen(), // Llamada HTTP y Future
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Aplicación con Tabs'),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Personal Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.api),
            label: 'API',
          ),
        ],
      ),
    );
  }
}

class PersonalInfoScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _makePhoneCall() async {
    const tel = 'tel:+525555555555'; // Número de teléfono para llamar
    if (await canLaunch(tel)) {
      await launch(tel);
    } else {
      throw 'No se pudo hacer la llamada';
    }
  }

  void _sendMessage() async {
    const sms = 'sms:+525555555555'; // Número para enviar mensaje
    if (await canLaunch(sms)) {
      await launch(sms);
    } else {
      throw 'No se pudo enviar el mensaje';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Información Personal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Imagen de perfil
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/tovar.jpeg'), // Imagen local
            ),
            SizedBox(height: 20),

            // Información personal
            Text(
              'Matrícula: 201236\nNombre: Miguel Ángel Tovar Reyes\nCorreo: 201236@ids.upchiapas.edu.mx\nRepositorio: https://github.com/Tovar188/M-vil-2-Union',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Botones de llamada y mensaje
            ElevatedButton(
              onPressed: _makePhoneCall,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Llamar'),
            ),
            ElevatedButton(
              onPressed: _sendMessage,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: Text('Enviar Mensaje'),
            ),

            SizedBox(height: 20),

            // Campos de texto (TextField)
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),

            // Botón para procesar los datos ingresados
            ElevatedButton(
              onPressed: () {
                print(
                    'Nombre: ${_nameController.text}, Correo: ${_emailController.text}');
              },
              child: Text('Procesar Datos'),
            ),
          ],
        ),
      ),
    );
  }
}

class ApiScreen extends StatefulWidget {
  @override
  _ApiScreenState createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  String _response = 'Esperando respuesta de la API...';

  // Future para obtener datos de la API
  Future<void> _fetchData() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _response =
            'Data: ${data['title']}'; // Muestra el campo "title" de la API
      });
    } else {
      setState(() {
        _response = 'Error al obtener los datos';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData(); // Llamada inicial a la API al cargar la pantalla
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pantalla API')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Texto que muestra los datos de la API
            Text(_response, style: TextStyle(fontSize: 16)),

            // Botón para obtener los datos de nuevo
            ElevatedButton(
              onPressed: _fetchData,
              child: Text('Obtener Datos'),
            ),
          ],
        ),
      ),
    );
  }
}
