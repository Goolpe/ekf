import 'dart:async';

import 'package:ekf/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class EkfChildrenProvider extends ChangeNotifier{
  EkfChild data = EkfChild();

  final _childController = StreamController<List<EkfChild>>.broadcast();
  Stream<List<EkfChild>> get dataList => _childController.stream;

  int _parentID;

  Future<void> getDataList({int parentID}) async {
    if(parentID != null){
      _parentID = parentID;
    }
    List<Map<String, dynamic>> _list = await DBProvider.db.getAll('Child', parentID: _parentID);
        
    List<EkfChild> list = _list.isNotEmpty 
      ? _list.map((c) => EkfChild.fromJson(c)).toList() 
      : [];

    _childController.sink.add(list);
  }

  void create(BuildContext context) async{
    if(data.dateOfBirth == null){
      data.dateOfBirth = DateTime.now();
    }
    data.parentID = _parentID;
    await DBProvider.db.insert('Child', data.toJson());
    await DBProvider.db.update('Employee', _parentID, 1);
    data = EkfChild();

    getDataList();
    Provider.of<EkfEmployeesProvider>(context, listen: false).getDataList();
  }

  void delete(BuildContext context, int id) async{
    await DBProvider.db.delete('Child', 'id', id);
    await DBProvider.db.update('Employee', _parentID, -1);

    getDataList();
    Provider.of<EkfEmployeesProvider>(context, listen: false).getDataList();
  }

  @override
  dispose() {
    _childController?.close();
    super.dispose();
  }
}