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
    id: json['id'],
    surname: json['surname'] ?? '', 
    name: json['name'] ?? '', 
    patronymic: json['patronymic'] ?? '', 
    dateOfBirth: fromIsoToDate(json['dateOfBirth']),
    position: json['position'] ?? 'Разработчик',
    amountOfChildren: json['amountOfChildren'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "surname": surname, 
    "name": name, 
    "patronymic": patronymic, 
    "dateOfBirth": dateOfBirth.toIso8601String(),
    "position": position,
    "amountOfChildren": amountOfChildren ?? 0,
  };
}