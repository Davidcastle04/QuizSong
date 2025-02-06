import 'dart:ffi';
import 'dart:math' as math;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform, );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'QuizSong'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}











// Clases para la Verificación e Identficación de los usuarios

class Password{

  // Atributos
      Long ?hashCockie;
      Long hashClave;

  // Métodos

      Password(this.hashCockie, this.hashClave);

      Password(this.hashClave,Password actual){
        hashCockie=actual.hashCockie;
      }

      bool compruebaClave(Long hashClaveIntroducida){
        // Hacer la magia con la base de datos
        return false;
      }
      bool compruebaCookies(Long hash){
        return hashCockie == hash;
      }

}


class Usuario {

  String id; // ID personal del usuario
  Map<String, List<mensaje>> mensajesAmigos = {}; // Mensajes con amigos
  List<String> amigos = []; // Lista de amigos
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Constructor
      Usuario(this.id);

  // Iniciar sesión (cargar datos desde Firestore)
      Future<void> iniciarSesion() async {
        DocumentSnapshot usuarioDoc = await _db.collection('usuarios').doc(id).get();

        if (usuarioDoc.exists) {
          Map<String, dynamic> data = usuarioDoc.data() as Map<String, dynamic>;
          amigos = List<String>.from(data['amigos'] ?? []);
          mensajesAmigos = (data['mensajesAmigos'] ?? {}).map<String, List<mensaje>>((key, value) => MapEntry(key, (value as List).map((msg) => mensaje.fromMap(msg)).toList(),),);
        }
      }

  // Finalizar sesión (guardar datos en Firestore)
      Future<void> finalizarSesion() async {
        await _db.collection('usuarios').doc(id).set({
          'amigos': amigos,
          'mensajesAmigos': mensajesAmigos.map((key, value) => MapEntry(key, value.map((msg) => msg.toMap()).toList(),),),
        });
      }

  // Getters 
      List<String> get obtenerAmigos => amigos;
      String get obtenId => id;

  // Obtener mensajes de un amigo
      List<mensaje> obtenerMensajeAmigo(String amigoId) {
        return mensajesAmigos[amigoId] ?? [];
      }

}


class mensaje{




}


class AID {
  /// Esta clase se encarga principalmente de la gestión de identificación de un usuario

    // Atributos de la clase AID

        int id=0;
        Password password;
        String nombre;
        String? descripcion;
        FileImage? imagenUsuario;
        static final math.Random _random = math.Random();

        // Constructores Parametrizados

        AID(this.nombre, this.password, this.descripcion) {
          id = _random.nextInt(1000000);
        }

        AID.withImage(this.nombre, this.password, this.imagenUsuario) {
          id = _random.nextInt(1000000);
        }

        AID.complete(this.nombre, this.password, this.descripcion, this.imagenUsuario) {
          id = _random.nextInt(1000000);
        }

    // Getters

        int get identificadorUsuario => id;
        String get nombreUsuario => nombre;
        FileImage? get imagenUsuarioGet => imagenUsuario;
        String? get descripcionUsuario => descripcion;
        Password get claveUsuario => password;

    // Setters

        set imagenUsuarioSet(FileImage imagenNueva) {
          imagenUsuario = imagenNueva;
        }

        set descripcionSet(String descripcionNueva) {
          descripcion = descripcionNueva;
        }

        set setPassword(Password claveNueva) {
          password=claveNueva;
        }
}