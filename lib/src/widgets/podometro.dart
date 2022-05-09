import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:etorax/src/blocs/ejerc_provider.dart';
import '../globals.dart' as globals;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import '../models/ejercicio.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';


class HealthApp extends StatefulWidget {
  final Ejercicio ejerc;
  @override
  _HealthAppState createState() => _HealthAppState();

  const HealthApp({ Key? key, required this.ejerc }): super(key: key);


}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_NOT_ADDED,
  STEPS_READY,
}
class _HealthAppState extends State<HealthApp> {
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;
  int _nofSteps = 10;
  double distDelta = 10.0;
  HealthFactory health = HealthFactory();

  /// Fetch data points from the health plugin and show them in the app.
  Future fetchData() async {
    setState(() => _state = AppState.FETCHING_DATA);

    // define the types to get
    final types = [
      HealthDataType.DISTANCE_DELTA,
      HealthDataType.MOVE_MINUTES,
      // Uncomment this line on iOS - only available on iOS
      // HealthDataType.DISTANCE_WALKING_RUNNING,
    ];

    // with coresponsing permissions
    final permissions = [
      HealthDataAccess.READ,
      HealthDataAccess.READ,
    ];

    // get data within the last 24 hours
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    // requesting access to the data types before reading them
    // note that strictly speaking, the [permissions] are not
    // needed, since we only want READ access.
    bool requested =
    await health.requestAuthorization(types, permissions: permissions);

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> healthData =
        await health.getHealthDataFromTypes(midnight, now, types);

        // save all the new data points (only the first 100)
        _healthDataList.addAll((healthData.length < 100)
            ? healthData
            : healthData.sublist(0, 100));
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

      // print the results
      _healthDataList.forEach((x) => print(x));

      // update the UI to display the results
      setState(() {
        _state =
        _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
      });
    } else {
      print("Authorization not granted");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }



  /// Fetch steps from the health plugin and show them in the app.
  Future fetchStepData() async {
    int? steps;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

    if (requested) {
      try {
        steps = await health.getTotalStepsInInterval(midnight, now);
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }

      print('Total number of steps: $steps');

      setState(() {
        _nofSteps = (steps == null) ? 0 : steps;
        _state = (steps == null) ? AppState.NO_DATA : AppState.STEPS_READY;
      });
    } else {
      print("Authorization not granted");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }


  Widget _contentDataReady() {
    distDelta=0.0;
    _healthDataList.forEach((element) {
      if(element.typeString=='DISTANCE_DELTA'){
        print("EY");
        distDelta+=element.value;
      }else{
        print("otro");
        print("${element.typeString}");

      }
    });
    if(widget.ejerc.completado==1){
      return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.check, color: Colors.green),
              title: Text(widget.ejerc.nombre),
              subtitle: Text(widget.ejerc.descri),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(child: Text("${distDelta.toStringAsFixed(2)} metros de los ${widget.ejerc.cantidad} metros diarios", style: TextStyle(fontSize: 15)),),
              ],
            ),
          ],
        ),
      );
    }else{
      if(distDelta>=widget.ejerc.cantidad){
        return Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.pending_actions, color: Colors.red),
                title: Text(widget.ejerc.nombre),
                subtitle: Text(widget.ejerc.descri),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(child: Text("${distDelta.toStringAsFixed(2)} metros de los ${widget.ejerc.cantidad} metros diarios", style: TextStyle(fontSize: 15)),),
                ],
              ),
              OutlinedButton(
                onPressed: () {
                  completar();
                },
                child: Text("He finalizado  ✔"),
              ),
            ],
          ),
        );
      }else{
        return Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.pending_actions, color: Colors.red),
                title: Text(widget.ejerc.nombre),
                subtitle: Text(widget.ejerc.descri),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(child: Text("${distDelta.toStringAsFixed(2)} metros de los ${widget.ejerc.cantidad} metros diarios", style: TextStyle(fontSize: 15)),),
                ],
              ),
            ],
          ),
        );
      }
    }

  }





  Widget _stepsFetched() {
    return Text('Total number of steps: $_nofSteps');
  }



  @override
  Widget build(BuildContext context) {
    fetchData();
    return _contentDataReady();
  }

  Future<void> completar() async {
    Client client = Client();
    final respuesta = await client.post(
      Uri.parse('http://'+dotenv.env['server']!+'/paciente/completarEjer'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'access-token': globals.token,
      },
      body: jsonEncode(<String, String>{
        'pacId': globals.usuario,
        'idTratEjer': widget.ejerc.idTratEjer.toString(),
      }),
    );
    Map<String, dynamic> data = jsonDecode(respuesta.body);
    if(data['token']!=null) {
      globals.token = data['token'];
    }
    print("ALLEVOY");
    if(data['mensaje'].toString().contains("correctamente")){
      Navigator.popAndPushNamed(context, "menu");
    }
  }
}