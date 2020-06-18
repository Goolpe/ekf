import 'dart:async';

import 'package:ekf/index.dart';
import 'package:flutter/cupertino.dart';

class EkfEmployeesProvider extends ChangeNotifier{
  EkfEmployee data = EkfEmployee();

  final _employeeController = StreamController<List<EkfEmployee>>.broadcast();
  Stream<List<EkfEmployee>> get dataList => _employeeController.stream;

  List<String> positions = [
    'Менеджер',
    'Дизайнер',
    'Разработчик'
  ];

  Future<void> getDataList() async {
    List<Map<String, dynamic>> _list = await DBProvider.db.getAll('Employee');
        
    List<EkfEmployee> list = _list.isNotEmpty 
      ? _list.map((c) => EkfEmployee.fromJson(c)).toList() 
      : [];

    _employeeController.sink.add(list);
  }

  Future<void> create() async{
    if(data.dateOfBirth == null){
      data.dateOfBirth = DateTime.now();
    }
    await DBProvider.db.insert('Employee', data.toJson());
    data = EkfEmployee();
    getDataList();
  }

  void delete(int id){
    DBProvider.db.delete('Employee', 'id', id);
    DBProvider.db.delete('Child', 'parentID', id);
    getDataList();
  }

  @override
  void dispose() {
    _employeeController?.close();
    super.dispose();
  }
}