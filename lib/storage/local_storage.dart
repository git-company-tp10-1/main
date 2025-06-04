import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../presentation/screens/notes.dart';

class LocalStorage {
  static const String _notesKey = 'saved_notes';

  Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = notes.map((note) => jsonEncode({
      'time': note.time,
      'title': note.title,
      'content': note.content,
      'day': note.day,
    })).toList();

    await prefs.setStringList(_notesKey, notesJson);
  }

  Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList(_notesKey) ?? [];

    return notesJson.map((json) {
      final data = jsonDecode(json);
      return Note(
        time: data['time'],
        title: data['title'],
        content: data['content'],
        day: data['day'],
      );
    }).toList();
  }
}