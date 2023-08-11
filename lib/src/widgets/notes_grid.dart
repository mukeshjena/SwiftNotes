import 'package:SwiftNotes/src/model/note.dart';
import 'package:SwiftNotes/src/widgets/notes_grid_item.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';

class NoteGrid extends StatelessWidget {
  const NoteGrid({super.key, required this.notes});

  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    return LiveGrid.options(
      padding: const EdgeInsets.all(20),
      itemBuilder: (context, index, animation) {
        return NoteGridItem(note: notes[index]);
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: notes.length,
      options: LiveOptions(),
    );
  }
}
