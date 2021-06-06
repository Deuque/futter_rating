import 'package:flutter/material.dart';

class RatingWidget extends StatefulWidget {
  final double size;
  final double spacing;
  final int initialRating;
  final Function(int rating) onRatingChanged;
  final bool readOnly;

  const RatingWidget(
      {Key key,
      this.size = 25,
      this.initialRating = 0,
      this.spacing = 8,
      this.onRatingChanged,
      this.readOnly = false})
      : super(key: key);

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  List<GlobalKey> starKeys = List.generate(5, (index) => GlobalKey());
  int rating;

  void onRatingChanged(int newRating) {
    widget.onRatingChanged(newRating);
    rating = newRating;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rating = rating;
  }

  @override
  Widget build(BuildContext context) {
    Color starColor = rating < 3
        ? Colors.redAccent
        : rating > 3
            ? Colors.green
            : Colors.orangeAccent;

    List<Widget> rated = List.generate(
        rating,
        (index) => GestureDetector(
              onTap: index == rating ? () {} : () => onRatingChanged(index + 1),
              child: StarWidget(
                starKey: starKeys[index],
                color: starColor,
                size: widget.size,
                spacing: widget.spacing,
              ),
            ));

    List<Widget> unRated = List.generate(
        5 - rating,
        (index) => GestureDetector(
              onTap: widget.readOnly
                  ? null
                  : () => onRatingChanged(rating + index + 1),
              child: StarWidget(
                starKey: starKeys[rating+index],
                size: widget.size,
                spacing: widget.spacing,
              ),
            ));

    return Padding(
      padding: const EdgeInsets.only(top: 7.0, bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [...rated, ...unRated],
      ),
    );
  }
}

class StarWidget extends StatelessWidget {
  final Color color;
  final double size;
  final double spacing;
  final GlobalKey starKey;

  const StarWidget({Key key, this.color, this.size, this.spacing,this.starKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        duration: Duration(milliseconds: 300),
        tween: ColorTween(
            begin: Colors.grey.withOpacity(.3),
            end: color ?? Colors.grey.withOpacity(.3)),
        builder: (_, Color color, child) {
          return Padding(
            padding: EdgeInsets.all(spacing),
            child: Image.asset(
              'assets/png/star.png',
              key: starKey,
              color: color,
              height: size,
            ),
          );
        });
  }
}

extension GlobalKeyEx on GlobalKey {
  Rect get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null)?.getTranslation();
    if (translation != null && renderObject.paintBounds != null) {
      return renderObject.paintBounds
          .shift(Offset(translation.x, translation.y));
    } else {
      return null;
    }
  }
}