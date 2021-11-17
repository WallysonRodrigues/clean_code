import 'features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:flutter/material.dart';
import 'injector_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.deepPurple.shade500;
                } else if (states.contains(MaterialState.disabled)) {
                  return Colors.purple.shade50;
                }

                return Colors.deepPurple;
              },
            ),
          ),
        ),
        disabledColor: Colors.purple[100],
      ),
      home: const NumberTriviaPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
