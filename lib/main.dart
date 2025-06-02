import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/controller/note_controller.dart';
import 'package:notes_app/service/note_service.dart'; 
import 'package:notes_app/views/home_screen.dart';
import 'package:notes_app/views/note_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final noteService = await Get.putAsync(() => NoteService().init());
  Get.put(NoteController());


  runApp(
    GetMaterialApp(
      title: 'My Notes',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomeScreen()),
        GetPage(name: '/note', page: () => NoteScreen()),
      ],
    ),
  );
}
