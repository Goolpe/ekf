import 'package:ekf/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EkfEditorScreen extends StatefulWidget {
  EkfEditorScreen({
    @required this.formKey,
    @required this.person,
    this.children,
    this.onReady,
    this.title
  }) : assert(formKey != null, person != null);

  final GlobalKey<FormState> formKey;
  final List<Widget> children;
  final Function() onReady;
  final EkfPerson person;
  final String title;

  @override
  _EkfEditorScreenState createState() => _EkfEditorScreenState();
}

class _EkfEditorScreenState extends State<EkfEditorScreen> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? ''),
          centerTitle: true,
        ),
        body: Form(
          key: widget.formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            children: <Widget>[
              EkfFormField(
                label: 'Фамилия',
                child: EkfTextField(
                  initialValue: widget.person.surname,
                  onChanged: (String value) =>
                    widget.person.surname = value,
                  onSaved: (String value) =>
                    widget.person.surname = value.trim(),
                )
              ),
              EkfFormField(
                label: 'Имя',
                child: EkfTextField(
                  initialValue: widget.person.name,
                  onChanged: (String value) =>
                    widget.person.name = value,
                  onSaved: (String value) =>
                    widget.person.name = value.trim(),
                ),
              ),
              EkfFormField(
                label: 'Отчество',
                child: EkfTextField(
                  initialValue: widget.person.patronymic,
                  onChanged: (String value) =>
                    widget.person.patronymic = value,
                  onSaved: (String value) =>
                    widget.person.patronymic = value.trim(),
                ),
              ),
              EkfFormField(
                label: 'Дата Рождения',
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1.0,
                          color: Colors.black54
                        ),  
                      )
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    child: Text(formatDate(widget.person.dateOfBirth)),
                  ),
                  onTap: (){
                    FocusScope.of(context).unfocus();
                    _pickDateDialog();
                  }
                ),
              ),
              if(widget.children != null)
                Column(
                  children: widget.children
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: FloatingActionButton.extended(
                  elevation: 0,
                  onPressed: () => _create(), 
                  label: Text('Готово')
                ),
              )
            ]
          )
        )
      )
    );
  }

  void _create(){
    if (widget.formKey.currentState.validate()) {
      widget.formKey.currentState.save();
      widget.onReady();
      Get.back();
    }
  }

  void _pickDateDialog() {
    showDatePicker(
      context: context,
      initialDate: widget.person.dateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now()).then((pickedDate) {
        if (pickedDate == null) {
          return;
        }
        widget.person.dateOfBirth = pickedDate;
        setState(() { });
    });
  }
}