import 'dart:developer';
import 'package:SwiftNotes/src/model/note.dart';
import 'package:SwiftNotes/src/res/assets.dart';
import 'package:SwiftNotes/src/services/local_db.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
import 'package:lottie/lottie.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key, this.note});

  final Note? note;

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final localDb = LocalDBService();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
    }
  }

  @override
  void dispose() {
    super.dispose();

    final title = _titleController.text;
    final desc = _descriptionController.text;

    if (title.isNotEmpty || desc.isNotEmpty) {
      // Save only if either title or description is not empty
      if (widget.note != null) {
        if (widget.note!.title != title || widget.note!.description != desc) {
          final newNote = widget.note!.copyWith(
            title: title,
            description: desc,
          );
          localDb.saveNote(note: newNote);
        }
      } else {
        final newNote = Note(
          id: Isar.autoIncrement,
          title: title,
          description: desc,
          lastMod: DateTime.now(),
        );
        localDb.saveNote(note: newNote);
      }
    }

    _titleController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
                widget.note != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Delete Note ?',
                                      style: GoogleFonts.poppins(fontSize: 20),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Lottie.asset(AnimationAssets.delete),
                                        Text(
                                          'This note will be permanently deleted.',
                                          style:
                                              GoogleFonts.poppins(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          localDb.deleteNote(
                                              id: widget.note!.id);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Proceed"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                    ],
                                  );
                                });
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                ),
                style: GoogleFonts.poppins(fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Description',
                ),
                style: GoogleFonts.poppins(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
