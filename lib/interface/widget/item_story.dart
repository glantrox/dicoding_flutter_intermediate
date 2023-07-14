import 'package:flutter/material.dart';
import 'package:submission_intermediate/core/utils/string.dart';

import '../../core/models/story.dart';

class ItemStory extends StatelessWidget {
  final Function onTap;
  final Story story;
  const ItemStory({super.key, required this.story, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.maxFinite,
        height: 120,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Stack(
          children: [
            SizedBox(
              width: double.maxFinite,
              height: double.maxFinite,
              child: FittedBox(
                  clipBehavior: Clip.hardEdge,
                  fit: BoxFit.cover,
                  child: Image.network(story.photoUrl ?? "")),
            ),
            Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        toCapitalize(story.description ?? ""),
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        story.name ?? "",
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 234, 234, 234),
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
