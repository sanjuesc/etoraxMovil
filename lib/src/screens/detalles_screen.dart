import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/ejercicio.dart';
import '../widgets/podometro.dart';
class DetallesScreen extends StatelessWidget{

  final Ejercicio ejer;
  const DetallesScreen({Key? key, required this.ejer}) : super (key : key);


  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(ejer.nombre),
      ),
      body: SlidingUpPanel(
        panel: Container(
          height: double.infinity,
          width: double.infinity,
          child: videoWidget(),
        ),
        body: Center(
          child: HealthApp(),
        ),
        maxHeight: 480.0,
      ),
    );
  }

  videoWidget() {
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: 'b788DieJTo0',
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: true,
      ),
    );

    return YoutubePlayer(
      controller: _controller,
      bottomActions: [CurrentPosition(),
      ProgressBar(isExpanded: true,),],
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.amber,
      onReady: () {
        _controller.addListener(() {

        },);
        },
    );
  }



}
