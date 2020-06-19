import 'package:ekf/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class EkfEmployeesScreen extends StatelessWidget {

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
              ? EkfEmptyList(
                fab: _fab(),
              )
              : EkfStackList(
                fab: _fab(),
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    EkfEmployee _data = snapshot.data[index];

                    return Card(
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        child: ListTile(
                          title: Text(_data.surname + ' ' + 
                            _data.name + ' ' + 
                            _data.patronymic
                          ),
                          subtitle: Text(_data.position.toString()),
                          trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(formatDate(_data.dateOfBirth)),
                                if(_data.amountOfChildren > 0)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text('Детей: ${_data.amountOfChildren}'),
                                  )
                              ],
                            ),
                          onTap: () => Get.to<EkfChildrenScreen>(
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
                              Provider.of<EkfEmployeesProvider>(context, listen: false)
                                .delete(_data.id);
                            }
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else{
              return Center(
                child: CircularProgressIndicator()
              );
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
      label: Text('Добавить сотрудника'),
      onPressed: () => Get.to<Widget>(
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
                    onChanged: (String value) =>
                      state.data.position = value,
                    onSaved: (String value) =>
                      state.data.position = value.trim(),
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