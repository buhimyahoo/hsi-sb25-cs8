import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:submission8/bloc/auth/auth_bloc.dart';
import 'package:submission8/bloc/note/note_bloc.dart';
import 'package:submission8/screens/add_edit_note.dart';
import 'package:submission8/screens/login_screen.dart';
import 'package:submission8/screens/note_screen.dart';
import 'package:submission8/screens/register_screen.dart';
import 'package:submission8/services/note/note_api_service.dart';
import 'package:submission8/services/user/user_api_service.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(UserApiServiceImpl()),
        ),
        BlocProvider<NoteBloc>(
          create: (context) => NoteBloc(NoteApiServiceImpl()),
        ),
      ],
      child: MaterialApp(
        title: 'HSI Notes',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/add_edit_note': (context) => AddEditNote(),
          '/note_screen': (context) => NoteScreen(),
        },
        builder: EasyLoading.init(),
      ),
    );
  }
}
