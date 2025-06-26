import 'package:flutter/material.dart';

class PlayerRow extends StatelessWidget {
  final String name;
  final String country;
  final int position;
  final String avatarPath;

  const PlayerRow({
    super.key,
    required this.name,
    required this.country,
    required this.position,
    required this.avatarPath,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage(avatarPath),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              country,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        const Spacer(),
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.lime,
          child: Text(
            position.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        for (int i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.lime,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
      ],
    );
  }
}
