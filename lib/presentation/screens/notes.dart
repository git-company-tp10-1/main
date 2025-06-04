import 'package:flutter/material.dart';
import '../../service/api_service.dart';
import '../../storage/local_storage.dart';

class NotesScreen extends StatefulWidget {
  final String selectedDay;
  final String token;

  const NotesScreen({
    super.key,
    required this.selectedDay,
    required this.token,
  });

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final ApiService _apiService = ApiService();
  final LocalStorage _storageService = LocalStorage();
  List<Note> _notes = [];
  bool _isLoading = false;
  late String _currentDayAbbreviation;

  @override
  void initState() {
    super.initState();
    _currentDayAbbreviation = _getCurrentDayAbbreviation();
    _loadNotes();
  }

  String _getCurrentDayAbbreviation() {
    final now = DateTime.now();
    final day = now.weekday;
    const days = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];
    return days[day - 1];
  }

  bool get _isToday => widget.selectedDay == _currentDayAbbreviation;

  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    try {
      // Сначала пробуем загрузить с сервера
      // Здесь можно добавить загрузку с сервера

      // Затем загружаем из локального хранилища
      final localNotes = await _storageService.loadNotes();
      setState(() => _notes = localNotes);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addNewNote(Note newNote) async {
    if (!_isToday) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Можно добавлять заметки только на сегодня')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      // Отправляем на сервер
      await _apiService.notes(
        newNote.time,
        newNote.title,
        newNote.content,
      );

      // Добавляем в локальный список
      final updatedNotes = [..._notes, newNote];
      setState(() => _notes = updatedNotes);

      // Сохраняем в локальное хранилище
      await _storageService.saveNotes(updatedNotes);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при сохранении заметки: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteNote(Note note) async {
    if (!_isToday) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Можно удалять только заметки за сегодня')),
      );
      return;
    }

    if (note.day != _currentDayAbbreviation) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Нельзя удалять заметки за другие дни')),
      );
      return;
    }

    final confirmed = await _showDeleteConfirmationDialog();

    if (!confirmed) return;

    setState(() => _isLoading = true);
    try {
      // Удаляем с сервера
      await _apiService.deleteNote(note.time);

      // Удаляем из локального списка
      final updatedNotes = _notes.where((n) => n.time != note.time).toList();
      setState(() => _notes = updatedNotes);

      // Сохраняем в локальное хранилище
      await _storageService.saveNotes(updatedNotes);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заметка удалена')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при удалении заметки: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить заметку?'),
        content: const Text('Вы уверены, что хотите удалить эту заметку?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Удалить', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // Фильтруем заметки по выбранному дню
    final filteredNotes = _notes.where((note) => note.day == widget.selectedDay).toList();

    return Scaffold(
      floatingActionButton: _isLoading
          ? const CircularProgressIndicator()
          : _isToday
          ? FloatingActionButton(
        onPressed: () => _showAddNoteDialog(context),
        backgroundColor: const Color(0xFF86DBB2),
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: Container(
          width: 383,
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFBBDDCC),
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: Colors.black26, width: 1),
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
              Padding(
                padding: const EdgeInsets.only(top: 19, bottom: 33),
                child: Text(
                  _getDayName(widget.selectedDay),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontFamily: 'Crimson Text',
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ),
              if (!_isToday)
                const Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Text(
                    'Редактирование доступно только для текущего дня',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              else if (filteredNotes.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Text(
                    'Нет заметок на этот день',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                    ),
                  ),
                )
              else
                ...filteredNotes.map((note) => _buildNoteItem(note)).toList(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoteItem(Note note) {
    return GestureDetector(
      onLongPress: () => _isToday ? _deleteNote(note) : null,
      child: Column(
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
                bottom: BorderSide(color: Colors.black26, width: 1.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(String dayAbbreviation) {
    final days = {
      'ПН': 'Понедельник',
      'ВТ': 'Вторник',
      'СР': 'Среда',
      'ЧТ': 'Четверг',
      'ПТ': 'Пятница',
      'СБ': 'Суббота',
      'ВС': 'Воскресенье',
    };
    return days[dayAbbreviation] ?? dayAbbreviation;
  }

  void _showAddNoteDialog(BuildContext context) {
    if (!_isToday) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return AddNoteDialog(
          selectedDay: widget.selectedDay,
          onSave: _addNewNote,
        );
      },
    );
  }
}

class AddNoteDialog extends StatefulWidget {
  final String selectedDay;
  final Function(Note) onSave;

  const AddNoteDialog({
    super.key,
    required this.selectedDay,
    required this.onSave,
  });

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  int _selectedHour = DateTime.now().hour;
  int _selectedMinute = DateTime.now().minute;
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
          Text(
            'Добавить заметку на ${widget.selectedDay}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text('Выберите время:', style: TextStyle(fontSize: 16)),
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
                  day: widget.selectedDay,
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
        onSelectedItemChanged: onChanged,
        children: List.generate(max, (index) => Center(
          child: Text(
            index.toString().padLeft(2, '0'),
            style: const TextStyle(fontSize: 24),
          ),
        )),
      ),
    );
  }
}

class Note {
  final String time;
  final String title;
  final String content;
  final String day;

  const Note({
    required this.time,
    required this.title,
    required this.content,
    required this.day,
  });

  Map<String, dynamic> toJson() => {
    'time': time,
    'title': title,
    'content': content,
    'day': day,
  };

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      time: json['time'],
      title: json['title'],
      content: json['content'],
      day: json['day'],
    );
  }
}