import 'package:flutter/material.dart';

class FilterDrawer extends StatefulWidget {
  final String selectedDifficulty;
  final String selectedCategory;
  final Function(String, String) onApplyFilters;

  const FilterDrawer({
    Key? key,
    required this.selectedDifficulty,
    required this.selectedCategory,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  _FilterDrawerState createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  late String _difficulty;
  late String _category;

  @override
  void initState() {
    super.initState();
    _difficulty = widget.selectedDifficulty;
    _category = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '필터',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '난이도',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _difficulty,
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                  value: 'all',
                  child: Text('전체'),
                ),
                DropdownMenuItem(
                  value: 'easy',
                  child: Text('쉬움'),
                ),
                DropdownMenuItem(
                  value: 'medium',
                  child: Text('보통'),
                ),
                DropdownMenuItem(
                  value: 'hard',
                  child: Text('어려움'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _difficulty = value;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            const Text(
              '카테고리',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _category,
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                  value: 'all',
                  child: Text('전체'),
                ),
                DropdownMenuItem(
                  value: 'vocabulary',
                  child: Text('어휘'),
                ),
                DropdownMenuItem(
                  value: 'grammar',
                  child: Text('문법'),
                ),
                DropdownMenuItem(
                  value: 'reading',
                  child: Text('독해'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _category = value;
                  });
                }
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApplyFilters(_difficulty, _category);
                  Navigator.pop(context);
                },
                child: const Text('적용'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
