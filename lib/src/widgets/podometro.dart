import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:etorax/src/blocs/ejerc_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../globals.dart' as globals;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import '../models/ejercicio.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';


class HealthApp extends StatefulWidget {
  final Ejercicio ejerc;
  final PanelController pc;
  @override
  _HealthAppState createState() => _HealthAppState();

  const HealthApp({ Key? key, required this.ejerc, required this.pc }): super(key: key);


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
  num _tiempo = 0;
  HealthFactory health = HealthFactory();

  /// Fetch data points from the health plugin and show them in the app.
  Future fetchData() async {
    final types = [
      HealthDataType.DISTANCE_DELTA,
      HealthDataType.MOVE_MINUTES,

    ];

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
        _healthDataList.addAll(healthData);
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
    int algo=0;
    _healthDataList.forEach((element) {
      print(element.typeString);
      print(algo);
      algo++;
      if(element.typeString=='DISTANCE_DELTA'){
        distDelta+=element.value;
      }else{
        _tiempo+=element.value;
      }
    });
    print(_tiempo);
    if(widget.ejerc.completado==1){
      double prop = distDelta/widget.ejerc.cantidad;
      String porc = (prop*100).toStringAsFixed(2);
      return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.pending_actions, color: Colors.green),
              title: Text(widget.ejerc.nombre),
              subtitle: Text(widget.ejerc.descri),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularPercentIndicator(
                  radius: 140.0,
                  progressColor: Colors.green,
                  percent: 1,
                  circularStrokeCap: CircularStrokeCap.round,
                  animation: true,
                  lineWidth: 11.0,
                  center: new Text(
                    "100.0%",
                    style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Text("${distDelta.toStringAsFixed(2)} metros de los ${widget.ejerc.cantidad} metros diarios", style: TextStyle(fontSize: 15)),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20, color: Color(0xFF6200EE)),
                  ),
                  onPressed: () {
                    widget.pc.isAttached ? widget.pc.open() : print("no estaba");
                  },
                  child: const Text("Ver video"),
                ),
              ],
            ),



          ],
        ),
      );
    }else{
      if(distDelta>=widget.ejerc.cantidad){
        double prop = distDelta/widget.ejerc.cantidad;
        String porc = (prop*100).toStringAsFixed(2);
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularPercentIndicator(
                    radius: 140.0,
                    progressColor: Colors.green,
                    percent: 1,
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    lineWidth: 11.0,
                    center: new Text(
                      "100.0%",
                      style:
                      new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                  ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Text("${distDelta.toStringAsFixed(2)} metros de los ${widget.ejerc.cantidad} metros diarios", style: TextStyle(fontSize: 15)),
              ),
              OutlinedButton(
                onPressed: () {
                  completar();
                },
                child: Text("Finalizar ejercicio"),
              ),
            ],
          ),
        );
      }else{
        double prop = distDelta/widget.ejerc.cantidad;
        String porc = (prop*100).toStringAsFixed(2);
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularPercentIndicator(
                    radius: 140.0,
                    progressColor: Colors.green,
                    percent: prop,
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    lineWidth: 11.0,
                    center: new Text(
                      "$porc%",
                      style:
                      new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                ]
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text("${distDelta.toStringAsFixed(2)} metros de los ${widget.ejerc.cantidad} metros diarios", style: TextStyle(fontSize: 15)),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, 20.0, 0.0, 0.0),
                child: Text("Si la distancia no se actualiza correctamente, puedes completar el ejercicio mediante el botón de abajo", style: TextStyle(fontSize: 15)),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20, color: Color(0xFF6200EE)),
                    ),
                    onPressed: () {
                      completar();
                    },
                    child: const Text("Completar manualmente"),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20, color: Color(0xFF6200EE)),
                    ),
                    onPressed: () {
                      widget.pc.isAttached ? widget.pc.open() : print("no estaba");
                    },
                    child: const Text("Ver video"),
                  ),
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
    print(widget.ejerc.nombre);
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
    } else if(_state == AppState.CARGANDO){
      return Center(child: CircularProgressIndicator());
    }else{
      return Align(child: preguntar(), alignment: Alignment.topCenter,);

    }


  }

  Future<void> completar() async {
    Client client = Client();
    print("COMPLETAR #############################");
    final respuesta = await client.post(
      Uri.parse('https://'+dotenv.env['server']!+'/paciente/completarEjer'),
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
    print("QUE VIENE");
    print(data);
    if(data['token']!=null) {
      globals.token = data['token'];
    }
    if(data.toString().contains("correctamente")){
      Navigator.pushReplacementNamed(context, "menu");
    }
  }






  Widget preguntar(){
    return Card(
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
          height: 150,
          decoration: BoxDecoration(color: Colors.white60),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 2.0, color: Colors.grey))),
              child: Icon(Icons.directions_walk, color: Colors.grey),
            ),
            title: Text("eTorax puede detectar tu progreso automaticamente mediante el podometro de tu movil"),
            subtitle: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Row(
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                setManu();
                                setState(() {
                                  _state=AppState.MANUAL;
                                });
                              },
                              child: Text("Manual"),
                            ),
                            SizedBox(width: 70.0,),
                            OutlinedButton(
                              onPressed: () {
                                setAuto();
                                setState(() {
                                  _state=AppState.AUTOMATICO;
                                });
                              },
                              child: Text("Automatica"),
                            ),
                          ],
                        )
            ),
          )
      ),
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