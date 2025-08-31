import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission8/bloc/note/note_bloc.dart';
import 'package:submission8/bloc/note/note_event.dart';
import 'package:submission8/widgets/custom_text.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    super.key,
    required this.onTap,
    required this.onCreate,
    required this.updatedAt,
  });

  final VoidCallback onTap;
  final VoidCallback onCreate;
  final DateTime? updatedAt;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: SafeArea(
        child: updatedAt != null
            ? Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: CustomRegularText(
                        text:
                            'Last edited on ${updatedAt?.hour}:${updatedAt?.minute}',
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.all(12),
                      child: Icon(
                        Icons.more_horiz_rounded,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextButton(
                  onPressed: onCreate,
                  child: Text('Save note'),
                ),
              ),
      ),
    );
  }
}

class BottomActionSection extends StatelessWidget {
  const BottomActionSection({
    super.key,
    required this.id,
    required this.title,
    required this.content,
  });

  final String id;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[400],
                    ),
                    child: Icon(Icons.close_rounded, size: 20),
                  ),
                ),
              ],
            ),
            buildTile(
              icon: Icons.check_rounded,
              label: 'Save note',
              onTap: () {
                context.read<NoteBloc>().add(
                  UpdateNoteEvent(id: id, title: title, content: content),
                );
              },
            ),
            Divider(),
            buildTile(
              icon: Icons.delete_rounded,
              label: 'Delete Note',
              color: Colors.red,
              onTap: () {
                context.read<NoteBloc>().add(DeleteNoteEvent(id));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTile({
    required IconData icon,
    required String label,
    Color? color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Row(
          spacing: 16,
          children: [
            Icon(icon, color: color),
            Expanded(child: CustomRegularText(text: label)),
          ],
        ),
      ),
    );
  }
}
