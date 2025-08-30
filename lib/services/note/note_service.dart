import 'package:submission8/model/note_model.dart';

abstract class NoteService {
  Future<List<NoteModel>> notes();

  Future<bool> create({required String title, required String content});

  Future<bool> update({
    required String id,
    required String title,
    required String content,
  });

  Future<bool> delete(String id);
}
