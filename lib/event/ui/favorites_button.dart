import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_state/reactive_state.dart';

import 'favorites_list.dart';
import '../state.dart';

/// Button for accessing favorites from [AppBar].
class FavoritesButton extends StatefulWidget {
  FavoritesButton({Key key, this.animationTrigger}) : super(key: key);

  /// Intended to trigger an animation whenever the number of favorites changes.
  /// Usually, this stream is only based on actual user interactions
  /// instead of observing the list of favorites.
  final Stream<void> animationTrigger;

  @override
  _FavoritesButtonState createState() => _FavoritesButtonState();
}

class _FavoritesButtonState extends State<FavoritesButton>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  StreamSubscription<void> subscription;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 100), vsync: this);
    animation = Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeIn))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
        }
      });
    subscription = widget.animationTrigger
        ?.listen((_) => animationController.forward(from: 0.0));
  }

  @override
  void dispose() {
    subscription?.cancel();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<EventState>(context);
    return IconButton(
      icon: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
            alignment: AlignmentDirectional.topCenter,
            child: ScaleTransition(scale: animation, child: Icon(Icons.stars)),
          ),
          Container(
            alignment: AlignmentDirectional.bottomEnd,
            child: AutoBuild(
                builder: (context, get, track) =>
                    Text('${get(state.favorites).length}')),
          ),
        ],
      ),
      onPressed: () => state.global.navigate(FavoritesList()),
    );
  }
}
