import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission8/bloc/note/note_event.dart';
import 'package:submission8/bloc/note/note_state.dart';
import 'package:submission8/services/note/note_service.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc(this.service) : super(NoteState.initial()) {
    on<NoteEvent>((event, emit) async {
      final notes = await service.notes();

      emit(state.copyWith(notes: notes, status: NoteStates.initial));
    });

    on<CreateNoteEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: NoteStates.loading));

        await service.create(content: event.content, title: event.title);

        emit(state.copyWith(status: NoteStates.success));

        add(GetNoteEvent());
      } on Exception catch (e) {
        emit(state.copyWith(status: NoteStates.failure, error: e));
      }
    });

    on<UpdateNoteEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: NoteStates.loading));

        await service.update(
          id: event.id,
          content: event.content,
          title: event.title,
        );

        emit(state.copyWith(status: NoteStates.success));

        add(GetNoteEvent());
      } on Exception catch (e) {
        emit(state.copyWith(status: NoteStates.failure, error: e));
      }
    });

    on<DeleteNoteEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: NoteStates.loading));

        await service.delete(event.id);

        emit(state.copyWith(status: NoteStates.success));

        add(GetNoteEvent());
      } on Exception catch (e) {
        emit(state.copyWith(status: NoteStates.failure, error: e));
      }
    });
  }

  final NoteService service;
}
