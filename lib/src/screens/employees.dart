import 'package:ekf/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class EkfHomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Сотрудники'),
          centerTitle: true,
        ),
        body: StreamBuilder<List<EkfEmployee>>(
          stream: Provider.of<EkfEmployeesProvider>(context, listen: false).dataList,
          builder: (context, AsyncSnapshot<List<EkfEmployee>> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text('Здесь пока никого =)'),
                    ),
                    _fab()
                  ],
                ),
              )
              : Stack(
                children: [
                  ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      EkfEmployee _data = snapshot.data[index];

                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        child: ListTile(
                          title: Text(_data.surname + ' ' + 
                            _data.name + ' ' + 
                            _data.patronymic
                          ),
                          subtitle: Text(_data.position.toString()),
                          trailing: 
                          _data.amountOfChildren > 0
                          ? Column(
                            children: [
                              Text(formatDate(_data.dateOfBirth)),
                              Text('Детей: ${_data.amountOfChildren}')
                            ],
                          ) : Text(formatDate(_data.dateOfBirth)),
                          onTap: () => Get.to(
                            EkfChildrenScreen(
                              id: _data.id, 
                              title: _data.name
                            )
                          ),
                        ),
                        secondaryActions: [
                          IconSlideAction(
                            caption: 'Удалить',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: (){
                              Provider.of<EkfEmployeesProvider>(context, listen: false).delete(_data.id);
                            }
                          ),
                        ],
                      );
                    },
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: _fab(),
                  )
                ],
              );
            } else{
              return SizedBox();
            }
          }
        )
      ),
    );
  }

  Widget _fab(){
    final _formKey = GlobalKey<FormState>();

    return FloatingActionButton.extended(
      elevation: 0,
      label: Text('Добавить'),
      onPressed: () => Get.to(
        Consumer<EkfEmployeesProvider>(
          builder: (context, state, snapshot) {
            return EkfEditorScreen(
              title: 'Добавить сотрудника',
              formKey: _formKey,
              person: state.data,
              children: <Widget>[
                EkfFormField(
                  label: 'Должность',
                  child: EkfTextField(
                    items: state.positions.map((String position) {
                      return DropdownMenuItem(
                        value: position,
                        child: Text(position),
                        );
                      }
                    ).toList(),
                    initialValue: state.data.position,
                    onChanged: (String value){
                      state.data.position = value;
                    },
                  )
                )
              ],
              onReady: () => 
                Provider.of<EkfEmployeesProvider>(context, listen: false).create()
            );
          }
        )
      ),
    );
  }
}