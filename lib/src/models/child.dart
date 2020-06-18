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
    id: json['id'],
    surname: json['surname'] ?? '', 
    name: json['name'] ?? '', 
    patronymic: json['patronymic'] ?? '', 
    dateOfBirth: fromIsoToDate(json['dateOfBirth']),
    parentID: json['parentID'] ?? 0
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "surname": surname, 
    "name": name, 
    "patronymic": patronymic, 
    "dateOfBirth": dateOfBirth.toIso8601String(),
    'parentID': parentID
  };
}