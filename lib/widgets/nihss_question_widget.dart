import 'package:flutter/material.dart';

class NIHSSQuestionWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final int value;
  final List<String> options;
  final ValueChanged<int> onChanged;

  const NIHSSQuestionWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
            const SizedBox(height: 10),
            ...options.asMap().entries.map((entry) {
              int index = entry.key;
              String option = entry.value;
              bool isSelected = value == index;
              
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                child: RadioListTile<int>(
                  title: Text(
                    option,
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected ? Colors.blue : Colors.black87,
                    ),
                  ),
                  value: index,
                  groupValue: value,
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      onChanged(newValue);
                    }
                  },
                  activeColor: Colors.blue,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
