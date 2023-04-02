import 'package:bart/bart/widgets/bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';

class BottomBarIntent extends Intent {
  final bool state;

  const BottomBarIntent(this.state);

  factory BottomBarIntent.show() => const BottomBarIntent(true);

  factory BottomBarIntent.hide() => const BottomBarIntent(false);
}

class BottomBarAction extends Action<BottomBarIntent> {
  ValueNotifier<bool> show;

  BottomBarAction(this.show);

  @override
  void invoke(covariant BottomBarIntent intent) {
    show.value = intent.state;
  }
}

class AnimatedBottomBar extends StatelessWidget {
  final ValueNotifier<bool> showStateNotifier;
  final BartBottomBar bottomBar;

  const AnimatedBottomBar({
    Key? key,
    required this.showStateNotifier,
    required this.bottomBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: showStateNotifier,
      builder: (context, show, child) => Stack(
        children: [
          AnimatedPositioned(
            curve: Curves.decelerate,
            duration: const Duration(milliseconds: 300),
            bottom: show ? 0 : 150,
            left: 0,
            right: 0,
            child: bottomBar,
          ),
        ],
      ),
    );
  }
}

mixin BartNotifier {
  void showBottomBar(BuildContext context) {
    _runWhenReady(
      context,
      () => Actions.invoke(context, BottomBarIntent.show()),
    );
  }

  void hideBottomBar(BuildContext context) {
    _runWhenReady(
      context,
      () => Actions.invoke(context, BottomBarIntent.hide()),
    );
  }

  _runWhenReady(BuildContext context, Function onReady) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onReady();
    });
  }
}
