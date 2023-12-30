import 'package:flutter/material.dart';
import 'package:kjbn/providers/dataprovider.dart';
import 'package:kjbn/timerWidget.dart';
import 'package:provider/provider.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AnimatedSplashScreen(
        splash: 'assets/images/kjbn_logo.jpg',
        splashIconSize: 150,
        pageTransitionType: PageTransitionType.rightToLeftWithFade,
        duration: 1500,
        nextScreen: ChangeNotifierProvider<DataProvider>(
            create: (_) => DataProvider(),
            child: MyHomePage(title: 'KJBN CODING PROBLEM')),
      ),
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
  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() async {
    await Provider.of<DataProvider>(context, listen: false).fetchStoredData();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DataProvider>(context, listen: true);
    Status _status = provider.status;
    // int _attempts = provider.attempts;
    // int success = provider.success;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                      color: const Color(0xFFdde8fa),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Color(0xFFa4b7d8),
                        width: 2,
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Current second",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Divider(),
                      Text("${provider.presentTime}")
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                      color: const Color(0xFFdfd5e6),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Color(0xFFa993b7),
                        width: 2,
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Random Number",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Divider(),
                      Text("${provider.randomNumber}")
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Card(
                elevation: 3,
                color: _status == Status.success
                    ? const Color(0xFF57a456)
                    : const Color(0xFFf5bf4b),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _status == Status.success
                          ? "SUCCESS :)"
                          : _status == Status.failed
                              ? "SORRY TRY AGAIN"
                              : "TIMED OUT",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const Divider(),
                    _status == Status.success
                        ? Text(
                            "Score : ${provider.success} / ${provider.attempts}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500))
                        : _status == Status.failed
                            ? Text("Attempts ${provider.attempts}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500))
                            : Text(
                                "Sorry , Timed Out \n Attempts ${provider.attempts}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TimerWidget(seconds: provider.seconds),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                onPressed: () => provider.onClickListen(),
                child: const Text(
                  'Click',
                  style: TextStyle(color: Colors.white),
                )),
            ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                onPressed: () => provider.onClickListen(clearAttempts: true),
                child: const Text(
                  'Clear All Attempts',
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
