import 'package:leavetheoffice/data/data_manager.dart';

DataManager _dataManager;

DataManager getDataManager(){
  if(_dataManager == null){
    _dataManager = new DataManager();
  }
  return _dataManager;
}