import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../service/api_service.dart';

class GoalsScreen extends StatefulWidget {
  final ApiService _apiService = ApiService();

  GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  List<Goal> goals = [];
  bool _isLoading = true;
  bool _syncInProgress = false;

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? goalsJson = prefs.getString('goals');

      if (goalsJson != null) {
        final List<dynamic> decoded = json.decode(goalsJson);
        setState(() {
          goals = decoded.map((e) => Goal.fromJson(e)).toList();
        });
      }

      await _syncWithServer();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки целей: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveGoalsLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(goals.map((e) => e.toJson()).toList());
    await prefs.setString('goals', encoded);
  }

  Future<void> _syncWithServer() async {
    if (_syncInProgress) return;

    setState(() {
      _syncInProgress = true;
    });

    try {
      final serverGoals = await widget._apiService.getGoals();

      final serverGoalsConverted = serverGoals.map((serverGoal) => Goal(
        title: utf8.decode(latin1.encode(serverGoal['content'] ?? 'Без названия')),
        cardColor: serverGoal['createdByUser'] == true
            ? const Color(0xFF40CE9F)
            : const Color(0xFF86DBB2),
        circleColor: serverGoal['createdByUser'] == true
            ? const Color(0xFFBBDDCC)
            : const Color(0xFF86DBB2),
        createdByUser: serverGoal['createdByUser'] == true,
        isCompleted: serverGoal['status'] != 'ACTIVE',
        isSynced: true,
      )).toList();

      setState(() {
        goals = [
          ...serverGoalsConverted,
          ...goals.where((localGoal) =>
          localGoal.isSynced == false ||
              !serverGoalsConverted.any((serverGoal) =>
              serverGoal.title == localGoal.title))
        ];
      });

      await _saveGoalsLocally();
    } catch (e) {
      debugPrint('Ошибка синхронизации: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки целей: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _syncInProgress = false;
      });
    }
  }

  Future<void> _deleteGoal(int index) async {
    final goalToDelete = goals[index];
    final confirmed = await _showDeleteConfirmationDialog(goalToDelete.title);

    if (!confirmed) return;

    try {
      setState(() {
        goals.removeAt(index);
      });

      await _saveGoalsLocally();

      if (goalToDelete.isSynced) {
        await widget._apiService.deleteGoal(goalToDelete.title);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Цель "${goalToDelete.title}" удалена')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка удаления: ${e.toString()}')),
      );
      setState(() {
        goals.insert(index, goalToDelete);
      });
    }
  }

  Future<bool> _showDeleteConfirmationDialog(String goalTitle) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить цель?'),
        content: Text('Вы уверены, что хотите удалить цель "$goalTitle"?'),
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

  Future<void> _generateAIGoals() async {
    try {
      setState(() {
        _syncInProgress = true;
      });

      await widget._apiService.getGoalsAI();
      await _syncWithServer();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Цели сгенерированы ИИ')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка генерации целей: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _syncInProgress = false;
      });
    }
  }

  void _toggleGoalCompletion(int index) async {
    setState(() {
      goals[index].isCompleted = !goals[index].isCompleted;
    });
    await _saveGoalsLocally();

    if (goals[index].isSynced) {
      try {
        // Здесь должен быть вызов API для обновления статуса
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка обновления статуса: ${e.toString()}')),
        );
        setState(() {
          goals[index].isCompleted = !goals[index].isCompleted;
        });
      }
    }
  }

  void _addNewGoal() {
    showDialog(
      context: context,
      builder: (context) => GoalEditDialog(
        onSave: (title) async {
          try {
            final newGoal = Goal(
              title: title,
              cardColor: const Color(0xFFAAE8CE),
              circleColor: const Color(0xFFCCF0ED),
              isSynced: false,
              createdByUser: false,
            );

            setState(() {
              goals.insert(0, newGoal);
            });

            await _saveGoalsLocally();
            await _syncWithServer();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Ошибка сохранения цели: ${e.toString()}')),
            );
          }
        },
      ),
    );
  }

  void _editGoal(int index) {
    if (goals[index].createdByUser) return;

    showDialog(
      context: context,
      builder: (context) => GoalEditDialog(
        initialText: goals[index].title,
        onSave: (newTitle) async {
          setState(() {
            goals[index].title = newTitle;
            goals[index].isSynced = false;
          });
          await _saveGoalsLocally();
          await _syncWithServer();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDEE),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  if (goals.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'У вас пока нет целей',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _generateAIGoals,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9EFFD0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Сгенерировать цели ИИ для теста',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  for (int i = 0; i < goals.length; i++)
                    _buildGoalCard(goals[i], i),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            if (_syncInProgress)
              Positioned(
                bottom: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Синхронизация...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (goals.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: FloatingActionButton.extended(
                onPressed: _generateAIGoals,
                backgroundColor: const Color(0xFF9EFFD0),
                icon: const Icon(Icons.auto_awesome, color: Colors.black),
                label: const Text('ИИ генерация(тест)', style: TextStyle(color: Colors.black)),
              ),
            ),
          FloatingActionButton(
            onPressed: _addNewGoal,
            backgroundColor: const Color(0xFF9EFFD0),
            child: const Icon(Icons.add, color: Colors.black),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildGoalCard(Goal goal, int index) {
    return GestureDetector(
      onLongPress: () => _deleteGoal(index),
      onTap: () => _editGoal(index),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: goal.createdByUser ? 96 : 80,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: ShapeDecoration(
          color: goal.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 20,
              top: 20,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  goal.title,
                  style: const TextStyle(
                    color: Color(0xFF1F2024),
                    fontSize: 18,
                    fontFamily: 'Crimson Text',
                    fontWeight: FontWeight.w400,
                    height: 1.11,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 20,
              top: goal.createdByUser ? 32 : 25,
              child: GestureDetector(
                onTap: () => _toggleGoalCompletion(index),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: ShapeDecoration(
                    color: goal.isCompleted
                        ? const Color(0xFF33322E)
                        : goal.circleColor,
                    shape: const OvalBorder(
                      side: BorderSide(
                        width: 3,
                        color: Color(0xFF33322E),
                      ),
                    ),
                  ),
                  child: goal.isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : null,
                ),
              ),
            ),
            if (goal.createdByUser)
              Positioned(
                left: 20,
                bottom: 16,
                child: Text(
                  'Сгенерировано на основе ваших действий',
                  style: TextStyle(
                    color: const Color(0xFF494949),
                    fontSize: 12,
                    fontFamily: 'Crimson Text',
                    fontWeight: FontWeight.w400,
                    height: 2,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class GoalEditDialog extends StatefulWidget {
  final Function(String) onSave;
  final String? initialText;

  const GoalEditDialog({
    super.key,
    required this.onSave,
    this.initialText,
  });

  @override
  State<GoalEditDialog> createState() => _GoalEditDialogState();
}

class _GoalEditDialogState extends State<GoalEditDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialText == null ? 'Новая цель' : 'Редактировать цель'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Введите текст цели',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              widget.onSave(_controller.text.trim());
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF9EFFD0),
          ),
          child: const Text('Сохранить', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}

class Goal {
  String title;
  final Color cardColor;
  final Color circleColor;
  final bool createdByUser;
  bool isCompleted;
  bool isSynced;

  Goal({
    required this.title,
    required this.cardColor,
    required this.circleColor,
    required this.createdByUser,
    this.isCompleted = false,
    this.isSynced = true,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      title: json['title'],
      cardColor: Color(json['cardColor']),
      circleColor: Color(json['circleColor']),
      createdByUser: json['createdByUser'],
      isCompleted: json['isCompleted'] ?? false,
      isSynced: json['isSynced'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'cardColor': cardColor.value,
      'circleColor': circleColor.value,
      'createdByUser': createdByUser,
      'isCompleted': isCompleted,
      'isSynced': isSynced,
    };
  }
}