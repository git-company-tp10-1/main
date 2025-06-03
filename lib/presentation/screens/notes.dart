import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const NotesScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final List<Note> _notes = [

  ];

  void _addNewNote(Note newNote) {
    setState(() {
      _notes.add(newNote);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNoteDialog(context),
        backgroundColor: const Color(0xFF86DBB2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: Container(
          width: 383,
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFBBDDCC),
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: Colors.black, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 19, bottom: 33),
                child: Text(
                  'Воскресенье',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontFamily: 'Crimson Text',
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ),
              ..._notes.map((note) => _buildNoteItem(note)).toList(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoteItem(Note note) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 60,
                child: Text(
                  note.time,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      note.content,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 24,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black, width: 1.0),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return AddNoteDialog(onSave: _addNewNote);
      },
    );
  }
}

class AddNoteDialog extends StatefulWidget {
  final Function(Note) onSave;

  const AddNoteDialog({super.key, required this.onSave});

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  int _selectedHour = 9;
  int _selectedMinute = 0;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20,
        right: 20,
        top: 20,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFBBDDCC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Выберите время:', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNumberScroll(_selectedHour, 24, (value) {
                setState(() => _selectedHour = value);
              }, isHour: true),
              const Text(':', style: TextStyle(fontSize: 24)),
              _buildNumberScroll(_selectedMinute, 60, (value) {
                setState(() => _selectedMinute = value);
              }, isHour: false),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Название заметки',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(
              labelText: 'Текст заметки',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              alignLabelWithHint: true,
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              if (_titleController.text.isNotEmpty) {
                final time = '${_selectedHour.toString().padLeft(2, '0')}:'
                    '${_selectedMinute.toString().padLeft(2, '0')}';
                widget.onSave(Note(
                  time: time,
                  title: _titleController.text,
                  content: _contentController.text,
                ));
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Сохранить',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberScroll(int value, int max, Function(int) onChanged,
      {required bool isHour}) {
    return Container(
      height: 150,
      width: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListWheelScrollView(
        itemExtent: 50,
        diameterRatio: 1.5,
        physics: const FixedExtentScrollPhysics(),
        children: List.generate(max, (index) => Center(
          child: Text(
            index.toString().padLeft(2, '0'),
            style: const TextStyle(fontSize: 24),
          ),
        )),
        onSelectedItemChanged: onChanged,
      ),
    );
  }
}

class Note {
  final String time;
  final String title;
  final String content;

  const Note({
    required this.time,
    required this.title,
    required this.content,
  });
}