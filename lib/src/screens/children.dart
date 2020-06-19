import 'package:ekf/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class EkfChildrenScreen extends StatefulWidget {
  EkfChildrenScreen({
    @required this.id,
    this.title
  }) : assert(id != null && title != null);

  final int id;
  final String title;

  @override
  _EkfChildrenScreenState createState() => _EkfChildrenScreenState();
}

class _EkfChildrenScreenState extends State<EkfChildrenScreen> {
  
  @override
  void initState() {
    Future.microtask(() =>
      Provider.of<EkfChildrenProvider>(context, listen: false)
        .init(widget.id)
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: StreamBuilder<List<EkfChild>>(
        stream: Provider.of<EkfChildrenProvider>(context, listen: false).dataList,
        builder: (context, AsyncSnapshot<List<EkfChild>> snapshot) {
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
                  return Card(
                    child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      child: ListTile(
                        title: Text(snapshot.data[index].surname + ' ' + 
                          snapshot.data[index].name + ' ' + 
                          snapshot.data[index].patronymic
                        ),
                        trailing: Text(formatDate(snapshot.data[index].dateOfBirth)),
                      ),
                      secondaryActions: [
                        IconSlideAction(
                          caption: 'Удалить',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: (){
                            Provider.of<EkfChildrenProvider>(context, listen: false)
                              .delete(context, snapshot.data[index].id);
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
    );
  }

  Widget _fab(){
    final _formKey = GlobalKey<FormState>();

    return FloatingActionButton.extended(
      elevation: 0,
      label: Text('Добавить ребенка'),
      onPressed: () => Get.to<Widget>(
        EkfEditorScreen(
          title: 'Добавить ребенка',
          formKey: _formKey,
          person: Provider.of<EkfChildrenProvider>(context, listen: false).data,
          onReady: () => 
            Provider.of<EkfChildrenProvider>(context, listen: false).create(context)
        )
      ),
    );
  }
}