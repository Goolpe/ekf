import 'package:ekf/index.dart';

class EkfChild extends EkfPerson{
  EkfChild({
    int id,
    String surname, 
    String name, 
    String patronymic, 
    DateTime dateOfBirth,
    this.parentID,
  }) : super(
    id,
    surname, 
    name, 
    patronymic, 
    dateOfBirth
  );

  int parentID;

  factory EkfChild.fromJson(Map<String, dynamic> json) => EkfChild(
    id: json['id'] as int,
    surname: json['surname'] as String ?? '', 
    name: json['name'] as String ?? '', 
    patronymic: json['patronymic'] as String ?? '', 
    dateOfBirth: fromIsoToDate(json['dateOfBirth'] as String ),
    parentID: json['parentID'] as int ?? 0
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    "id": id,
    "surname": surname, 
    "name": name, 
    "patronymic": patronymic, 
    "dateOfBirth": dateOfBirth.toIso8601String(),
    'parentID': parentID
  };
}