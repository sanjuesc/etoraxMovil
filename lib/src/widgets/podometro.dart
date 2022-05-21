import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:etorax/src/blocs/ejerc_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  FETCHING_DATA,
  AUTH_NOT_GRANTED,
  MANUAL,
  AUTOMATICO,
  CARGADO,
  CARGANDO
}
class _HealthAppState extends State<HealthApp> {
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.AUTH_NOT_GRANTED;
  int _nofSteps = 10;
  double distDelta = 10.0;
  HealthFactory health = HealthFactory();

  /// Fetch data points from the health plugin and show them in the app.
  Future fetchData() async {
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

      // update the UI to display the results
      setState(() {
        _state =
        _healthDataList.isEmpty ? AppState.CARGANDO : AppState.CARGADO;
      });
    } else {
      print("Authorization not granted");

    }
  }


  Widget _contentDataReady() {
    distDelta=0.0;
    _healthDataList.forEach((element) {
      if(element.typeString=='DISTANCE_DELTA'){
        distDelta+=element.value;
      }else{
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
    getPrefs();
    if(_state == AppState.MANUAL) {
      return Text("Manual");
    }else if(_state == AppState.CARGADO){
      return _contentDataReady();
    }else if (_state == AppState.AUTOMATICO){
      fetchData();
      return Center(child: CircularProgressIndicator(),);
    } else if (_state == AppState.AUTH_NOT_GRANTED){
      return Center(child: CircularProgressIndicator(),);
    } else{
      return preguntar();
    }


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
    if(data['mensaje'].toString().contains("correctamente")){
      Navigator.pushReplacementNamed(context, "menu");
    }
  }

  Widget preguntar() {
    return Column(
      children: [Text("eTorax puede detectar tu progreso automaticamente mediante el podometro de tu movil"),
        OutlinedButton(
          onPressed: () {
            setManu();
            setState(() {
              _state=AppState.MANUAL;
            });
          },
          child: Text("Manual"),
        ),
        OutlinedButton(
          onPressed: () {
            setAuto();
            setState(() {
              _state=AppState.AUTOMATICO;
            });
          },
          child: Text("Automatica"),
        ),
      ]
    );
  }


  Future getPrefs() async{
    var prefs = await SharedPreferences.getInstance();
    String? modo = prefs.getString("modo");
    print(modo);
    print(_state);
    if(_state != AppState.CARGADO && _state != AppState.CARGANDO){
      if(modo == null && _state!=AppState.FETCHING_DATA){
        setState(() {
          _state=AppState.FETCHING_DATA;
        });
      }
      if(modo=="Automatico" && _state!=AppState.AUTOMATICO){
        print("era auto");
        setState(() {
          _state=AppState.AUTOMATICO;
        });
      }else if (modo=="Manual" && _state!=AppState.MANUAL){
        print("era manu");
        setState(() {
          _state=AppState.MANUAL;
        });
      }
    }
  }


  Future setAuto() async{
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("modo", "Automatico");
  }

  Future setManu() async{
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("modo", "Manual");
  }
}