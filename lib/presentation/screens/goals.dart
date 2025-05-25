import 'package:flutter/material.dart';

class Goal {
  String title;
  final Color cardColor;
  final Color circleColor;
  final bool isGenerated;
  bool isCompleted;

  Goal({
    required this.title,
    required this.cardColor,
    required this.circleColor,
    this.isGenerated = false,
    this.isCompleted = false,
  });
}

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final List<Goal> goals = [
    Goal(
      title: 'Пройти 10000 шагов',
      cardColor: const Color(0xFF40CD9E),
      circleColor: const Color(0xFFCFF4F0),
      isGenerated: true,
    ),
    Goal(
      title: 'Выпить 1 л воды',
      cardColor: const Color(0xFFBBDDCC),
      circleColor: const Color(0xFF8CD4CB),
    ),
    Goal(
      title: '30 минут без телефона',
      cardColor: const Color(0xFF86DBB2),
      circleColor: const Color(0xFFCFF4F0),
    ),
    Goal(
      title: 'Сходить на прогулку',
      cardColor: const Color(0xFFBBDDCC),
      circleColor: const Color(0xFF8CD4CB),
      isGenerated: true,
    ),
    Goal(
      title: 'Встать в 6 утра',
      cardColor: const Color(0xFF86DBB2),
      circleColor: const Color(0xFFCFF4F0),
    ),
  ];

  void _toggleGoalCompletion(int index) {
    setState(() {
      goals[index].isCompleted = !goals[index].isCompleted;
    });
  }

  void _addNewGoal() {
    showDialog(
      context: context,
      builder: (context) => GoalEditDialog(
        onSave: (title) {
          setState(() {
            goals.insert(
                0,
                Goal(
                  title: title,
                  cardColor: const Color(0xFF9EFFD0),
                  circleColor: const Color(0xFFCFF4F0),
                ));
          });
        },
      ),
    );
  }

  void _editGoal(int index) {
    showDialog(
      context: context,
      builder: (context) => GoalEditDialog(
        initialText: goals[index].title,
        onSave: (newTitle) {
          setState(() {
            goals[index].title = newTitle;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: Center(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    'Цели',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: 'Ledger',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (int i = 0; i < goals.length; i++)
                    GestureDetector(
                      onTap: () => _editGoal(i),
                      child: _buildGoalCard(goals[i], i),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewGoal,
        backgroundColor: const Color(0xFF9EFFD0),
        child: const Icon(Icons.add, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildGoalCard(Goal goal, int index) {
    return Container(
      width: 302,
      height: goal.isGenerated ? 96 : 66,
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
            left: 16,
            top: 16,
            child: SizedBox(
              width: 230,
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
            right: 16,
            top: goal.isGenerated ? 32 : 16,
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
          if (goal.isGenerated)
            Positioned(
              left: 16,
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
      title:
      Text(widget.initialText == null ? 'Новая цель' : 'Редактировать цель'),
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