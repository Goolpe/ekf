import 'package:ekf/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class EkfChildrenScreen extends StatefulWidget {
  EkfChildrenScreen({
    this.id,
    this.title
  });

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
        .getDataList(parentID: widget.id)
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
                    return Slidable(
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
                            Provider.of<EkfChildrenProvider>(context, listen: false).delete(snapshot.data[index].id);
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
    );
  }

  Widget _fab(){
    final _formKey = GlobalKey<FormState>();

    return FloatingActionButton.extended(
      elevation: 0,
      label: Text('Добавить'),
      onPressed: () => Get.to(
        EkfEditorScreen(
          title: 'Добавить ребенка',
          formKey: _formKey,
          person: Provider.of<EkfChildrenProvider>(context, listen: false).data,
          onReady: () => 
            Provider.of<EkfChildrenProvider>(context, listen: false).create()
        )
      ),
    );
  }
}