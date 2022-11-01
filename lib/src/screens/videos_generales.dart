import 'package:etorax/src/blocs/login_provider.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert';
import '../globals.dart' as globals;
class VideosGenerales extends StatefulWidget{

  State<StatefulWidget> createState() {
    return VideosGeneralesState();
  }

}



class VideosGeneralesState extends State<VideosGenerales>{ //hacer stateful widget https://api.flutter.dev/flutter/material/TextField-class.html
  bool ready= false;


  Widget build(BuildContext context) {
    final bloc = LoginProvider.of(context);
    final videos = bloc.videosGenerales;

    return Scaffold(
        appBar: AppBar(title: Text("Videos generales"),),
        body: ListView(
          children: [
            //Padding(padding: EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0), child: Text("Algunos videos que pueden resultar utiles:", style: TextStyle(fontSize: 20))),
            ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, int index){
                return ListView(
                  children: [
                    Padding(padding: EdgeInsets.only(bottom: 10.0, left: 20.0), child: Text(videos[index]['titulo'].toString(), style: TextStyle(fontSize: 15))),
                    videoWidget(videos[index]['id']),
                ],
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                );
              },
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
            ),
          ]
        )
    );
  }


  videoWidget(vidId) {
    if(vidId.runtimeType == String){
      YoutubePlayerController _controller = YoutubePlayerController(
        initialVideoId: vidId,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          loop: true,
        ),
      );
      return
        Container(
            margin: EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
            child:  YoutubePlayer(
              controller: _controller,
              bottomActions: [CurrentPosition(),
                ProgressBar(isExpanded: true,),],
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.amber,
              onReady: () {
                _controller.addListener(() {
                },);
              },
            )
        );
    }else{
      YoutubePlayerController _controller = YoutubePlayerController(
        initialVideoId: vidId.first,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          loop: true,
        ),
      );
      return
        Container(
            margin: EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
            child:  YoutubePlayer(
              controller: _controller,
              bottomActions: [CurrentPosition(),
                ProgressBar(isExpanded: true,),],
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.amber,
              onReady: () {
                _controller.addListener(() {
                },);
              },
              onEnded: (data){
                _controller
                    .load(vidId[(vidId.indexOf(data.videoId) + 1) % vidId.length]);
              },
            )
        );
    }

  }


}
