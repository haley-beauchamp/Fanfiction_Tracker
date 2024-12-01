import 'package:fanfiction_tracker_flutter/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class StarRating extends StatefulWidget {
  final ValueChanged<double> onRatingChanged;
  final bool isEditable;
  final double? initialRating;

  const StarRating({
    super.key,
    required this.onRatingChanged,
    this.isEditable = true,
    this.initialRating,
  });

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  double? _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: _rating ?? 0,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: GlobalVariables.secondaryColor,
      ),
      onRatingUpdate: widget.isEditable
          ? (rating) {
              setState(() {
                _rating = rating;
              });
              widget.onRatingChanged(rating);
            }
          : (rating) {}, 
      ignoreGestures: !widget.isEditable,
    );
  }
}
