import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Todo list',
        home: AnimatedSplashScreen(
            duration: 3000,
            splash: Image.asset('images/logo.png'),
            nextScreen: const Home(),
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.leftToRight,
            backgroundColor: Colors.blue));
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  List<String> tasks = [];
  insertData(context) {
    if (textController.text != '') {
      setState(() {
        tasks.add(textController.text);
      });
      textController.text = '';
      // print(tasks);
      Navigator.pop(context);
    } else {
      Alert(
              style: const AlertStyle(
                animationType: AnimationType.grow,
              ),
              context: context,
              title: "No Data in Text field",
              type: AlertType.error)
          .show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('To do app'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: tasks
                          .map((task) => TaskUI(
                              task: task,
                              delete: () {
                                setState(() {
                                  tasks.remove(task);
                                });
                              }))
                          .toList()),
                  FloatingActionButton(
                      onPressed: () {
                        showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30),
                                    bottom: Radius.zero)),
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: 400,
                                child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(children: [
                                      Form(
                                          key: _formKey,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                "Add task",
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextFormField(
                                                validator: (value) {
                                                  if (value == '') {
                                                    return 'Need some text';
                                                  }
                                                  return null;
                                                },
                                                controller: textController,
                                              ),
                                              const SizedBox(height: 20),
                                              ElevatedButton.icon(
                                                  onPressed: () =>
                                                      insertData(context),
                                                  label: const Text('Add task'),
                                                  icon: const Padding(
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      child: Icon(Icons
                                                          .add_to_photos_sharp)))
                                            ],
                                          ))
                                    ])),
                              );
                            });
                      },
                      child: (const Icon(Icons.add_circle_outlined)))
                ]),
          ),
        ));
  }
}

class TaskUI extends StatefulWidget {
  const TaskUI({super.key, required this.task, required this.delete});
  final String task;
  final Function delete;

  @override
  State<TaskUI> createState() => _TaskUIState();
}

class _TaskUIState extends State<TaskUI> {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(widget.task,
                style: const TextStyle(color: Colors.black, fontSize: 24)),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => widget.delete(),
              label: const Text("remove"),
              icon: const Icon(Icons.remove_circle),
            )
          ],
        ));
  }
}
