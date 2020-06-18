import 'package:intl/intl.dart';

String formatDate(DateTime date){
  final DateFormat _df = DateFormat("dd.MM.yyyy");
  String _date;

  try{
    _date = _df.format(date);
  } catch(e){}

  return _date ?? _df.format(DateTime.now());
}

DateTime fromIsoToDate(String isoDate){
  DateTime _date;

  try{
    _date = DateTime.parse(isoDate);
  } catch(e){}

  return _date ?? DateTime.now();
}