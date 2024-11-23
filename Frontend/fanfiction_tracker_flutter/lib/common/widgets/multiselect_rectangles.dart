import 'package:fanfiction_tracker_flutter/constants/global_variables.dart';
import 'package:flutter/material.dart';

class MultiselectRectangles extends StatefulWidget {
  final List<String> displayList;
  final ValueChanged<List<String>> onSelectionChanged;
  final bool isEditable;
  final List<String>? favoritesDisplayList;

  const MultiselectRectangles({
    super.key,
    required this.displayList,
    required this.onSelectionChanged,
    this.isEditable = true,
    this.favoritesDisplayList,
  });

  @override
  State<MultiselectRectangles> createState() => _MultiselectRectanglesState();
}

class _MultiselectRectanglesState extends State<MultiselectRectangles> {
  final Set<int> _selectedIndices = {};
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    if (widget.favoritesDisplayList != null) {
      for (int i = 0; i < widget.displayList.length; i++) {
        if (widget.favoritesDisplayList!.contains(widget.displayList[i])) {
          _selectedIndices.add(i);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsToDisplay = _isExpanded ? widget.displayList : widget.displayList.take(5).toList();

    return Column(
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: List.generate(itemsToDisplay.length, (index) {
            return GestureDetector(
              onTap: widget.isEditable ? () {
                setState(() {
                  if (_selectedIndices.contains(index)) {
                    _selectedIndices.remove(index);
                  } else {
                    _selectedIndices.add(index);
                  }
        
                  List<String> selectedStrings = _selectedIndices
                      .map((selectedIndex) => widget.displayList[selectedIndex])
                      .toList();
        
                  widget.onSelectionChanged(selectedStrings);
                });
              } : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: _selectedIndices.contains(index)
                      ? GlobalVariables.secondaryColor
                      : GlobalVariables.backgroundColor,
                  border: Border.all(color: Colors.black),
                ),
                child: Text(
                  itemsToDisplay[index],
                  style: TextStyle(
                    color: _selectedIndices.contains(index) ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }),
        ),
        if (widget.displayList.length > 5)
          TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(_isExpanded ? 'Show Less' : 'Show More'),
          ),
      ],
    );
  }
}
