import 'package:leavetheoffice/data/data_manager.dart';

DataManager _dataManager;

// DataManager는 앱 실행 최초 1회 생성
DataManager getDataManager(){
  if(_dataManager == null){
    _dataManager = new DataManager();
  }
  return _dataManager;
}