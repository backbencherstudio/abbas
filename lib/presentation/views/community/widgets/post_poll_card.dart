import 'package:flutter/material.dart';

class PostPollCard extends StatelessWidget {
  final List<MapEntry<String, int>> options;
  final int totalVotes;
  final int? selectedIndex;

  const PostPollCard({
    super.key,
    required this.options,
    required this.totalVotes,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < options.length; i++)
          _PollTile(
            label: options[i].key,
            percent: totalVotes == 0 ? 0 : options[i].value / totalVotes,
            selected: i == selectedIndex,
          ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '$totalVotes votes',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey),
          ),
        )
      ],
    );
  }
}

class _PollTile extends StatelessWidget {
  final String label;
  final double percent;
  final bool selected;

  const _PollTile({
    required this.label,
    required this.percent,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? base.primary : Colors.grey.shade700,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percent.clamp(0, 1),
              child: Container(
                decoration: BoxDecoration(
                  color: (selected ? base.primary : Colors.white12)
                      .withOpacity(.14),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                size: 18,
                color: selected ? base.primary : Colors.grey,
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(label)),
              Text('${(percent * 100).round()}%'),
            ],
          ),
        ],
      ),
    );
  }
}
