import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:task_flutter_app/pre_auth/login_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_flutter_app/pre_auth/register_screen.dart';
import 'package:task_flutter_app/post_auth/task_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final keyApplicationId = 'gnzIqkwAQ3pDgBZ50nm7MINa8jJw6MAXaIQjTWHj';
  final keyClientKey = 'mnrmY5BhL2i42lmqQiXeATEDXMI8bZPNzquQBQwS';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,  clientKey: keyClientKey, autoSendSessionId: true);
  // var firstObject = ParseObject('FirstClass')
  //   ..set('message', 'Hey ! First message from Flutter. Parse is now connected');
  // await firstObject.save();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType){
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: LoginScreen(),//const MyHomePage(title: 'Flutter Demo Home Page')
      );
    });
  }
}
//LoginScreen

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
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
