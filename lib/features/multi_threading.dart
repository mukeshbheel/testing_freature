import 'dart:isolate';

import 'package:flutter/material.dart';

class MultiThreadingExample extends StatefulWidget {
  const MultiThreadingExample({super.key});

  @override
  State<MultiThreadingExample> createState() => _MultiThreadingExampleState();
}

class _MultiThreadingExampleState extends State<MultiThreadingExample> {

  bool showMoreInfo = false;

  toggleShowMoreInfo(){
    setState(() {
      showMoreInfo = !showMoreInfo;
    });
  }

  heavyTask(num, context){
    int value = 0;
    for(int i = 0; i < num; i++){
      value++;
    }
    var snackBar = SnackBar(content: Text("Without Isolate : $value"),);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
   }



  isolateFunc(num, context) async{
    ReceivePort receivePort = ReceivePort();
    try{
      await Isolate.spawn(heavyTaskWithIsolate, [receivePort.sendPort, num]);
      final res = await receivePort.first;
      var snackBar = SnackBar(content: Text("With Isolate : $res"),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on Object{
      var snackBar = const SnackBar(content: Text("Isolation Failed"),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      receivePort.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('MultiThreading in Flutter', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
              const SizedBox(height: 10,),
              const Text('Since We know that Dart is a Single threaded language. When some extensive tasks are performed the Main thread gets stuck hence the Ui is frozen until that task is Completed. To overCome this We can use isolates to open the main thread for displaying UI elements only and provide different thread for running Heavy tasks.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400), textAlign: TextAlign.center,),
              const SizedBox(height: 50,),

              Image.asset("assets/ball.gif"),
              const SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                heavyTask(400000000, context);
              },
              style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()), child: const Text("RUN HeAVEY tASK"),),
              const SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                isolateFunc(400000000, context);
              },
                style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()), child: const Text("RUN HeAVEY tASK with ISOLATE"),
              ),


              const SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                toggleShowMoreInfo();
              },
                style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()), child: Text(" ${showMoreInfo ? "Hide" : "Show"} More Info"),
              ),

              if(showMoreInfo)
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 10.0, right: 10.0, bottom: 30),
                child: Text(multiThreadCode),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

int heavyTaskWithIsolate(List<dynamic> args){
  SendPort resultPort = args[0];
  int value = 0;
  for(int i = 0; i < args[1]; i++){
    value++;
  }
  Isolate.exit(resultPort, value);
}

 String multiThreadCode = '''
import 'dart:isolate';

import 'package:flutter/material.dart';

class MultiThreadingExample extends StatefulWidget {
  const MultiThreadingExample({super.key});

  @override
  State<MultiThreadingExample> createState() => _MultiThreadingExampleState();
}

class _MultiThreadingExampleState extends State<MultiThreadingExample> {

  bool showMoreInfo = false;

  toggleShowMoreInfo(){
    setState(() {
      showMoreInfo = !showMoreInfo;
    });
  }

  heavyTask(num, context){
    int value = 0;
    for(int i = 0; i < num; i++){
      value++;
    }
    var snackBar = SnackBar(content: Text("Without Isolate : \$value"),);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
   }



  isolateFunc(num, context) async{
    ReceivePort receivePort = ReceivePort();
    try{
      await Isolate.spawn(heavyTaskWithIsolate, [receivePort.sendPort, num]);
      final res = await receivePort.first;
      var snackBar = SnackBar(content: Text("With Isolate : \$res"),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on Object{
      var snackBar = const SnackBar(content: Text("Isolation Failed"),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      receivePort.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('MultiThreading in Flutter', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
              const SizedBox(height: 10,),
              const Text('Since We know that Dart is a Single threaded language. When some extensive tasks are performed the Main thread gets stuck hence the Ui is frozen until that task is Completed. To overCome this We can use isolates to open the main thread for displaying UI elements only and provide different thread for running Heavy tasks.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400), textAlign: TextAlign.center,),
              const SizedBox(height: 50,),

              const CircularProgressIndicator(),
              const SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                heavyTask(400000000, context);
              },
              style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()), child: const Text("RUN HeAVEY tASK"),),
              const SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                isolateFunc(400000000, context);
              },
                style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()), child: const Text("RUN HeAVEY tASK with ISOLATE"),
              ),


              const SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                toggleShowMoreInfo();
              },
                style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()), child: Text(" \${showMoreInfo ? "Hide" : "Show"} More Info"),
              ),

              if(showMoreInfo)
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 10.0, right: 10.0, bottom: 30),
                child: Text(multiThreadCode),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

int heavyTaskWithIsolate(List<dynamic> args){
  SendPort resultPort = args[0];
  int value = 0;
  for(int i = 0; i < args[1]; i++){
    value++;
  }
  Isolate.exit(resultPort, value);
}
''';
