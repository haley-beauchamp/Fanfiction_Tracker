import 'package:fanfiction_tracker_flutter/constants/global_variables.dart';
import 'package:flutter/material.dart';

class SingleSelectRectangles extends StatefulWidget {
  final List<String> displayList;
  final ValueChanged<String> onSelectionChanged;
  final bool isEditable;
  final String? initialSelection;

  const SingleSelectRectangles({
    super.key,
    required this.displayList,
    required this.onSelectionChanged,
    this.isEditable = true,
    this.initialSelection,
  });

  @override
  State<SingleSelectRectangles> createState() => _SingleSelectRectanglesState();
}

class _SingleSelectRectanglesState extends State<SingleSelectRectangles> {
  int _selectedIndex = 0;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    
    if (widget.initialSelection != null) {
      _selectedIndex = widget.displayList.indexOf(widget.initialSelection!);
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
                  _selectedIndex = index;

                  // Send the selected item to the callback
                  widget.onSelectionChanged(widget.displayList[index]);
                });
              } : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: _selectedIndex == index
                      ? GlobalVariables.secondaryColor
                      : GlobalVariables.backgroundColor,
                  border: Border.all(color: Colors.black),
                ),
                child: Text(
                  itemsToDisplay[index],
                  style: TextStyle(
                    color: _selectedIndex == index ? Colors.white : Colors.black,
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
