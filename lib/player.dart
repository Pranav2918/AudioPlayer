import 'package:audio_manager/audio_manager.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocalAudio extends StatefulWidget {
  const LocalAudio({Key? key}) : super(key: key);

  @override
  _LocalAudio createState() => _LocalAudio();
}

class _LocalAudio extends State<LocalAudio> {
  Duration _duration = const Duration();
  Duration _position = const Duration();
  AudioPlayer advancedPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();
  double? _sliderVolume;

  int? maxVol, currentVol;

  @override
  void initState() {
    super.initState();
    initPlayer();
    initPlatformState();
  }

  void initPlayer() {
    advancedPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: advancedPlayer);
    advancedPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        _duration = d;
      });
    });
    advancedPlayer.onAudioPositionChanged.listen((Duration d) {
      setState(() {
        _position = d;
      });
    });
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await AudioManager.instance.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: Colors.red,
        title: const Text("Player"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // ignore: deprecated_member_use
          RaisedButton(
            color: Colors.redAccent,
            onPressed: () {
              audioCache.play("inferno.mp3");
            },
            child: const Text(
              "Play",
              style: TextStyle(color: Colors.white),
            ),
          ),

          // ignore: deprecated_member_use
          RaisedButton(
            color: Colors.redAccent,
            onPressed: () {
              advancedPlayer.pause();
            },
            child: const Text(
              "Pause",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Slider(
            value: _sliderVolume ?? 0,
            onChanged: (value) {
              setState(() {
                _sliderVolume = (value * 100).round() / 100.0;

                AudioManager.instance.setVolume(value, showVolume: true);
              });
            },
          ),
          Text("Volume $_sliderVolume")
        ],
      ),
    );
  }
}
