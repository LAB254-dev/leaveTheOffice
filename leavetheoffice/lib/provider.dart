import 'package:leavetheoffice/data/data_manager.dart';
import 'package:leavetheoffice/data/database_helper.dart';
import 'package:leavetheoffice/page/page_manager.dart';

DataManager _dataManager;
DatabaseHelper _databaseHelper;
PageManager _pageManager;

// DataManager, DbHelper는 앱 실행 최초 1회 생성
DataManager getDataManager(){
  if(_dataManager == null){
    _dataManager = new DataManager();
  }

  return _dataManager;
}

DatabaseHelper getDatabaseHelper(){
  if(_databaseHelper == null){
    _databaseHelper = new DatabaseHelper();
  }

  return _databaseHelper;
}

PageManager getPageManager(){
  if(_pageManager == null){
    _pageManager = new PageManager();
  }
  return _pageManager;
}