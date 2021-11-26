import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leavetheoffice/components/custom_button.dart';
import 'package:leavetheoffice/data/music_data.dart';
import 'package:leavetheoffice/data/staff_info_data.dart';
import 'package:leavetheoffice/provider.dart';

class AlertPage extends StatefulWidget {
  static const routeName = '/alert';

  @override
  State<StatefulWidget> createState() {
    return _AlertPageState();
  }
}

class _AlertPageState extends State<AlertPage> {
  // 직원 정보
  String name = "OOO";
  Staff_info args;

  // 음악 재생
  AudioCache cache = new AudioCache();
  AudioPlayer player = new AudioPlayer();

  // 타이머
  Timer _timer;

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    audioPlay();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("앵무시계"),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 150,
                ),
                Image.asset(
                  "assets/Logo.png",
                  scale: 0.75,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      args.name,
                      style: TextStyle(
                          fontFamily: "NotoSans",
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "님",
                      style: TextStyle(fontSize: 18, fontFamily: "NotoSans"),
                    ),
                  ],
                ),
                Text(
                  "퇴근해주세요!",
                  style: TextStyle(fontSize: 18, fontFamily: "NotoSans"),
                ),
                SizedBox(height: 20),
                CustomButton("퇴근하기", _acceptClicked),
                CustomButton(
                  "취소",
                  _cancelClicked,
                  color: Color(0xFFE0E0E0),
                  textColor: Color(0xFF616161),
                ),
              ],
            )),
      ),
    );
  }

  @override
  void initState() {
    // 화면이 시작하자마자 음악 재생, 타이머 실행
    super.initState();
    _timer = new Timer(Duration(seconds: 45), () {
      _cancelClicked();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _acceptClicked() {
    // 퇴근하기 버튼을 클릭했을 때
    args.workState = WorkState.afterWork;
    stopAudioPlay();
    getPageManager().broadcastPop(args.id);
  }

  void _cancelClicked() {
    // 취소 버튼을 클릭했을 때
    stopAudioPlay();
    getPageManager().broadcastPop(args.id);
  }

  void audioPlay() async {
    // 음악 재생
    Music_data data =
        await getDataManager().getMusicData(args.musicId); //set audio file
    player = await cache.play(data.root);
  }

  void stopAudioPlay() {
    // 음악 종료
    player.stop();
  }
}
