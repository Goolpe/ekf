import 'package:ekf/index.dart';

class EkfEmployee extends EkfPerson{
  EkfEmployee({
    int id,
    String surname, 
    String name, 
    String patronymic, 
    DateTime dateOfBirth,
    this.amountOfChildren,
    this.position
  }) : super(
    id,
    surname, 
    name, 
    patronymic, 
    dateOfBirth,
  );
  
  String position;
  int amountOfChildren;

  factory EkfEmployee.fromJson(Map<String, dynamic> json) => EkfEmployee(
    id: json['id'] as int,
    surname: json['surname'] as String ?? '', 
    name: json['name'] as String ?? '', 
    patronymic: json['patronymic']  as String?? '', 
    dateOfBirth: fromIsoToDate(json['dateOfBirth'] as String),
    position: json['position'] as String ?? 'Разработчик',
    amountOfChildren: json['amountOfChildren'] as int ?? 0,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    "id": id,
    "surname": surname, 
    "name": name, 
    "patronymic": patronymic, 
    "dateOfBirth": dateOfBirth.toIso8601String(),
    "position": position,
    "amountOfChildren": amountOfChildren ?? 0,
  };
}