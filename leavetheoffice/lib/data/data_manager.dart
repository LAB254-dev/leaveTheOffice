import 'package:flutter/material.dart';
import 'package:leavetheoffice/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'staff_info_data.dart';

class DataManager{
  Future<Staff_info> getStaffInfo(int id) async {
    Database db = await getDatabaseHelper().getDatabase();
    List<Map<String, dynamic>> row = await db.query(Staff_info.memTableName, where: "${Staff_info.columnId} = ?", whereArgs: [id]);
    return getDatabaseHelper().rowToMem(row.single);
  }

  Future<List<Staff_info>> staffList() async {
    Database db = await getDatabaseHelper().getDatabase();
    List<Map<String, dynamic>> rows = await db.query(Staff_info.memTableName);
    if(rows.isEmpty){
      initData();
      List<Map<String, dynamic>> rows = await db.query(Staff_info.memTableName);
    }
    debugPrint(rows.isNotEmpty?"rows is not empty":"rows is empty");
    return rows.map((row) => getDatabaseHelper().rowToMem(row)).toList();
  }

  Future<void> addStaff(Staff_info newStaff) async {
    Database db = await getDatabaseHelper().getDatabase();
    db.insert(Staff_info.memTableName, getDatabaseHelper().memToRow(newStaff));
  }

  Future<void> updateStaff(int id, Staff_info info) async {
    Database db = await getDatabaseHelper().getDatabase();
    db.update(Staff_info.memTableName, getDatabaseHelper().memToRow(info), where: "${Staff_info.columnId} = ?", whereArgs: [id]);
  }

  Future<void> deleteStaff(int id) async {
    Database db = await getDatabaseHelper().getDatabase();
    db.delete(Staff_info.memTableName, where: "${Staff_info.columnId} = ?", whereArgs: [id]);
  }
  
  void initData(){
    addStaff(new Staff_info("이아영", "DESIGNER"));
    addStaff(new Staff_info("김도연", "DEVELOPER"));
    addStaff(new Staff_info("박지윤", "DEVELOPER"));
    addStaff(new Staff_info("박정아", "PM"));
    addStaff(new Staff_info("상한규", "INTERN"));
    addStaff(new Staff_info("당병진", "DEVELOPER"));
  }
}