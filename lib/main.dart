import 'package:ekf/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EkfEmployeesProvider>(
          create: (context) => EkfEmployeesProvider()..getDataList(),
        ),
        ChangeNotifierProvider<EkfChildrenProvider>(
          create: (context) => EkfChildrenProvider(),
        )
      ],
      child: GetMaterialApp(
        title: 'Ekf',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xffF0F1F5),
          appBarTheme: AppBarTheme(
            elevation: 0
          )
        ),
        home: EkfHomeScreen(),
      ),
    );
  }
}