import 'dart:async';

import 'package:ekf/index.dart';
import 'package:flutter/cupertino.dart';

class EkfChildrenProvider extends ChangeNotifier{
  EkfChild data = EkfChild();

  final _childController = StreamController<List<EkfChild>>.broadcast();
  Stream<List<EkfChild>> get dataList => _childController.stream;

  int _parentID;

  Future<void> getDataList({int parentID}) async {
    if(parentID != null){
      _parentID = parentID;
    }
    List<Map<String, dynamic>> _list = await DBProvider.db.getByID('Child', _parentID);
        
    List<EkfChild> list = _list.isNotEmpty 
      ? _list.map((c) => EkfChild.fromJson(c)).toList() 
      : [];

    _childController.sink.add(list);
  }

  Future<void> create() async{
    if(data.dateOfBirth == null){
      data.dateOfBirth = DateTime.now();
    }
    data.parentID = _parentID;
    await DBProvider.db.insert('Child', data.toJson());
    data = EkfChild();
    getDataList();
  }

  void delete(int id){
    DBProvider.db.delete('Child', 'id', id);
    getDataList();
  }

  @override
  dispose() {
    _childController?.close();
    super.dispose();
  }
}