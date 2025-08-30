import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:submission8/bloc/note/note_bloc.dart';
import 'package:submission8/bloc/note/note_event.dart';
import 'package:submission8/bloc/note/note_state.dart';
import 'package:submission8/model/note_arguments.dart';
import 'package:submission8/model/note_model.dart';
import 'package:submission8/widgets/bottom_navigation.dart';
import 'package:submission8/widgets/custom_text.dart';

class AddEditNote extends StatefulWidget {
  const AddEditNote({super.key, this.note});

  final NoteModel? note;

  @override
  State<AddEditNote> createState() => _AddEditNoteState();
}

class _AddEditNoteState extends State<AddEditNote> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool addNewNote = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as NoteArguments;
    final String existingId = args.id;
    _titleController.text = args.title;
    _contentController.text = args.content;
    if (existingId.isEmpty) {
      addNewNote = true;
    }

    return BlocListener<NoteBloc, NoteState>(
      listener: (context, state) {
        if (state.status == NoteStates.loading) {
          CircularProgressIndicator();
        }
        if (state.status == NoteStates.failure) {
          EasyLoading.showToast(state.error.toString());
        }
        if (state.status == NoteStates.success) {
          EasyLoading.dismiss();
          Navigator.pushNamed(context, '/note_screen');
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hint: CustomBigText(text: 'Title'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter note title';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _contentController,
                        decoration: InputDecoration(
                          hint: Text('Type your note here'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        maxLines: 10,
                        keyboardType: TextInputType.multiline,
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        bottomNavigationBar: BottomNavigation(
          key: widget.key,
          updatedAt: widget.note?.updatedAt,
          onTap: () {
            if (_formKey.currentState?.validate() == true) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return BottomActionSection(
                    key: widget.key,
                    id: widget.note!.id,
                    title: _titleController.text,
                    content: _contentController.text,
                  );
                },
              );
            }
          },
          onCreate: () {
            if (addNewNote) {
              context.read<NoteBloc>().add(
                CreateNoteEvent(
                  title: _titleController.text,
                  content: _contentController.text,
                ),
              );
            } else {
              context.read<NoteBloc>().add(
                UpdateNoteEvent(
                  id: existingId,
                  title: _titleController.text,
                  content: _contentController.text,
                ),
              );
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: const Text('Note updated')));
            }
          },
        ),
      ),
    );
  }
}
