import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leavetheoffice/components/music_list_component.dart';
import 'package:leavetheoffice/data/dorm_types.dart';
import 'package:leavetheoffice/data/music_data.dart';
import 'package:leavetheoffice/data/staff_info_data.dart';
import 'package:leavetheoffice/provider.dart';

class StaffDataManagement extends StatefulWidget {
  static const routeName = '/staff';
  @override
  State<StatefulWidget> createState() {
    return _StaffDataManagementState();
  }
}

class _StaffDataManagementState extends State<StaffDataManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("직원 정보 관리", style: TextStyle(fontFamily: "NotoSans")),
          centerTitle: true,
          actions: [IconButton(icon: Icon(Icons.add), onPressed: _addStaff)],
        ),
        body: FutureBuilder(
          future: getDataManager().staffList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              List<Staff_info> staffs = snapshot.data;
              return LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minWidth: constraints.maxWidth),
                        child: DataTable(
                            columns: _columnList(), rows: _createCells(staffs)),
                      ),
                    ),
                  ),
                ),
              );
            }
            return Center(child: Text("데이터 불러오기 실패"));
          },
        ));
  }

  List<DataColumn> _columnList() {
    // Data table의 Column name list
    // 코드 가독성을 위해 함수로 분리
    return [
      DataColumn(
          label: Text(
        "ID",
        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "NotoSans"),
      )),
      DataColumn(
          label: Text(
        "이름",
        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "NotoSans"),
      )),
      DataColumn(
          label: Text(
        "직책",
        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "NotoSans"),
      )),
      DataColumn(
          label: Text(
        "기숙사",
        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "NotoSans"),
      )),
      DataColumn(
          label: Text(
        "수정",
        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "NotoSans"),
      )),
      DataColumn(
          label: Text(
        "음악",
        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "NotoSans"),
      )),
      DataColumn(
          label: Text(
        "삭제",
        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "NotoSans"),
      ))
    ];
  }

  List<DataRow> _createCells(List<Staff_info> list) {
    // info list의 정보를 data row 형태로 변환
    List<DataRow> rows = [];
    for (int i = 0; i < list.length; i++) {
      rows.add(DataRow(cells: [
        DataCell((Text(
          list[i].id.toString(),
          style: TextStyle(fontFamily: "NotoSans"),
        ))),
        DataCell(Text(
          list[i].name,
          style: TextStyle(fontFamily: "NotoSans"),
        )),
        DataCell(Text(
          list[i].role,
          style: TextStyle(fontFamily: "NotoSans"),
        )),
        DataCell(
          Container(
            child: getIconOfDomitory(list[i].dorm),
            width: 40,
          ),
        ),
        DataCell(IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            _editStaff(list[i]);
          },
        )),
        DataCell(IconButton(
          icon: Icon(Icons.music_note),
          onPressed: () {
            _selectMusic(list[i]);
          },
        )),
        DataCell(IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            _deleteStaff(list[i]);
          },
        )),
      ]));
    }
    return rows;
  }

  final List<String> _dormList = ['그리핀도르', '래번클로', '슬리데린', '후플푸프'];

  String _dormSelected = '그리핀도르';

  String getDormName(DormType dorm) {
    String name;

    switch (dorm) {
      case DormType.GRYFFINDOR:
        name = "그리핀도르";
        break;
      case DormType.HUFFLEPUFF:
        name = "후플푸프";
        break;
      case DormType.RAVENCLAW:
        name = "래번클로";
        break;
      case DormType.SLYTHERIN:
        name = "슬리데린";
        break;
    }

    return name;
  }

  DormType getDormType(String dormName) {
    DormType type;

    switch (dormName) {
      case "그리핀도르":
        type = DormType.GRYFFINDOR;
        break;
      case "후플푸프":
        type = DormType.HUFFLEPUFF;
        break;
      case "래번클로":
        type = DormType.RAVENCLAW;
        break;
      case "슬리데린":
        type = DormType.SLYTHERIN;
        break;
    }

    return type;
  }

  Image getIconOfDomitory(DormType dorm) {
    String name;

    switch (dorm) {
      case DormType.GRYFFINDOR:
        name = "Griffindor";
        break;
      case DormType.HUFFLEPUFF:
        name = "Hufflepuff";
        break;
      case DormType.RAVENCLAW:
        name = "Ravenclaw";
        break;
      case DormType.SLYTHERIN:
        name = "Slytherin";
        break;
    }

    return Image.asset('assets/${name}.png');
  }

  void _addStaff() {
    // 직원 추가 버튼 클릭 시 팝업, 내용을 데이터베이스에 추가
    TextEditingController nameController = new TextEditingController();
    TextEditingController roleController = new TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          String dormBuffer = _dormSelected;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("직원 추가"),
              content: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "이름"),
                  ),
                  TextField(
                    controller: roleController,
                    decoration: InputDecoration(labelText: "직책"),
                  ),
                  DropdownButton<String>(
                    // hint: new Text('select dorm'),
                    isExpanded: true,
                    value: dormBuffer,
                    icon: Icon(Icons.arrow_drop_down),
                    onChanged: (String data) {
                      setState(() {
                        dormBuffer = data;
                      });
                    },
                    items:
                        _dormList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ]),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("취소")),
                ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty &&
                          roleController.text.isNotEmpty) {
                        getDataManager().addStaff(new Staff_info(
                            nameController.text,
                            roleController.text,
                            getDormType(dormBuffer), Music_data.DEFALUT_MUSIC_ID),
                            );
                        setState(() {});
                        Navigator.pop(context);
                      }
                    },
                    child: Text("저장")),
              ],
            );
          });
        });
  }

  void _editStaff(Staff_info info) {
    // 직원 정보 수정 버튼 함수
    TextEditingController nameController = new TextEditingController();
    TextEditingController roleController = new TextEditingController();
    nameController.text = info.name;
    roleController.text = info.role;

    String dormBuffer = getDormName(info.dorm);

    showDialog(
        context: context,
        builder: (context) {
          // String houseName = info.dorm;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("정보 수정"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: "이름"),
                    ),
                    TextField(
                      controller: roleController,
                      decoration: InputDecoration(labelText: "직책"),
                    ),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: dormBuffer,
                      icon: Icon(Icons.arrow_drop_down),
                      onChanged: (String data) {
                        setState(() {
                          dormBuffer = data;
                        });
                      },
                      items: _dormList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("취소")),
                ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty &&
                          roleController.text.isNotEmpty) {
                        info.dorm = getDormType(dormBuffer);
                        getDataManager().updateStaff(
                            info.id,
                            Staff_info(nameController.text, roleController.text,
                                getDormType(dormBuffer),
                                Music_data.DEFALUT_MUSIC_ID));
                        setState(() {});
                        Navigator.pop(context);
                      }
                    },
                    child: Text("저장")),
              ],
            );
          });
        });
  }

  void _deleteStaff(Staff_info info) {
    // 직원 삭제 버튼 함수
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("직원 삭제"),
              content: Text("${info.name}(${info.role}) 직원의 정보를 삭제하시겠습니까?"),
              actions: [
                TextButton(
                  child: Text("취소"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      getDataManager().deleteStaff(info.id);
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: Text("삭제"))
              ],
            ));
  }

  void _selectMusic(Staff_info info) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("음악 선택"),
              content: Container(
                  width: 300.0,
                  height: 300.0,
                  child: FutureBuilder(
                    future: getDataManager().getMusicList(),
                    builder: (context, snapshot) {
                      getDataManager().getMusicData(1).then((data) {
                        print(data);
                      });
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasData) {
                        List<Music_data> list = snapshot.data;
                        return MusicList(staff: info, musicList: list);
                      }
                      return Center(child: Text("데이터 불러오기 실패"));
                    },
                  )),
              actions: [
                TextButton(
                  child: Text("뒤로가기"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }
}
