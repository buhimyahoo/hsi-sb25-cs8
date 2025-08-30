import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission8/bloc/auth/auth_bloc.dart';
import 'package:submission8/bloc/auth/auth_event.dart';
import 'package:submission8/bloc/auth/auth_state.dart';
import 'package:submission8/bloc/note/note_bloc.dart';
import 'package:submission8/bloc/note/note_event.dart';
import 'package:submission8/bloc/note/note_state.dart';
import 'package:submission8/model/note_arguments.dart';
import 'package:submission8/model/note_model.dart';
import 'package:submission8/widgets/custom_text.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NoteBloc>().add(GetNoteEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStates.initial) {
          Navigator.pushNamed(context, '/login');
        }
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

        appBar: AppBar(
          title: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return Text(state.user?.name ?? '');
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(LogoutAuthEvent());
              },
              icon: Icon(Icons.exit_to_app_rounded),
              color: Colors.red,
            ),
          ],
        ),

        body: BlocBuilder<NoteBloc, NoteState>(
          builder: (context, state) {
            if (state.notes.isEmpty) {
              return _EmptyNote();
            }
            return _NoteList(notes: state.notes);
          },
        ),

        floatingActionButton: SizedBox(
          height: 64,
          width: 64,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/add_edit_note',
                  arguments: NoteArguments(id: '', title: '', content: ''),
                );
              },
              foregroundColor: Colors.white,
              backgroundColor: Color(0xFF394675),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(48),
              ),
              elevation: 0,
              child: Icon(Icons.add, size: 32),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyNote extends StatelessWidget {
  const _EmptyNote();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/notes_logo.png', height: 219, width: 245),
          SizedBox(height: 31),
          Text(
            'Start Your Journey',
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 1.2,
              color: Color(0xFF180E25),
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Every big step start with small step.\n Notes your first idea and start\n your journey!',
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 1.4,
              color: Color(0xFF827D89),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 31),
          Image.asset(
            height: 123,
            width: 169,
            'assets/images/curved_arrow.png',
          ),
        ],
      ),
    );
  }
}

class _NoteList extends StatelessWidget {
  const _NoteList({required this.notes});

  final List<NoteModel> notes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: notes.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/add_edit_note',
                arguments: NoteArguments(
                  id: notes[index].id,
                  title: notes[index].title,
                  content: notes[index].content,
                ),
              );
            },
            onLongPress: () {
              context.read<NoteBloc>().add(DeleteNoteEvent(notes[index].id));
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: const Text('Note deleted')));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(style: BorderStyle.solid),
                borderRadius: BorderRadiusGeometry.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CustomBigText(text: notes[index].title),
                    SizedBox(height: 16),
                    CustomSmallText(text: notes[index].content),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
