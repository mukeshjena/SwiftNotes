import 'package:SwiftNotes/src/model/note.dart';
import 'package:SwiftNotes/src/res/strings.dart';
import 'package:SwiftNotes/src/screens/create_note_screen.dart';
import 'package:SwiftNotes/src/services/local_db.dart';
import 'package:SwiftNotes/src/widgets/empty_view.dart';
import 'package:SwiftNotes/src/widgets/notes_grid.dart';
import 'package:SwiftNotes/src/widgets/notes_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isListView = true;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.appName,
          style: GoogleFonts.poppins(fontSize: 24),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isListView = !isListView;
              });
            },
            icon:
                Icon(isListView ? Icons.splitscreen_outlined : Icons.grid_view),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search notes by title',
                  suffixIcon: Icon(Icons.search, color: Colors.grey),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Color(0xFF67686D), fontSize: 16),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Note>>(
                stream: LocalDBService().listenAllNotes(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return EmptyView();
                  } else {
                    final notes = snapshot.data!;
                    final filteredNotes = notes.where((note) {
                      return note.title.toLowerCase().contains(searchQuery);
                    }).toList();
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: isListView
                          ? NotesList(notes: filteredNotes)
                          : NoteGrid(notes: filteredNotes),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CreateNoteScreen()),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Colors.grey,
        ),
      ),
    );
  }
}
