import 'package:flutter/material.dart';
import 'package:leavetheoffice/data/music_data.dart';
import 'package:leavetheoffice/data/staff_info_data.dart';
import 'package:leavetheoffice/provider.dart';

class MusicList extends StatefulWidget {
  final Staff_info staff;
  final List<MusicData> musicList;

  const MusicList({this.staff, this.musicList});

  @override
  _MusicListState createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  int _selectedIndex;

  @override
  Widget build(BuildContext context) {
    _selectedIndex = this.widget.staff.musicId - 1;
    return ListView.builder(
        itemCount: this.widget.musicList.length,
        itemBuilder: (context, index) => ListTile(
              title: Text(this.widget.musicList[index].title),
              subtitle: Text(this.widget.musicList[index].artist),
              selected: index == _selectedIndex,
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                  this.widget.staff.musicId = index + 1;
                  getDataManager()
                      .updateStaff(this.widget.staff.id, this.widget.staff);
                });
              },
            ));
  }
}
