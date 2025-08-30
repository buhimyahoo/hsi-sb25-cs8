import 'package:submission8/model/note_model.dart';

enum NoteStates { initial, loading, success, failure }

class NoteState {
  NoteState({
    this.status = NoteStates.initial,
    this.notes = const [],
    this.error,
  });

  factory NoteState.initial() => NoteState();

  final NoteStates status;
  final List<NoteModel> notes;
  final Exception? error;

  NoteState copyWith({
    NoteStates? status,
    List<NoteModel>? notes,
    Exception? error,
  }) {
    return NoteState(
      error: error,
      notes: notes ?? this.notes,
      status: status ?? this.status,
    );
  }
}
