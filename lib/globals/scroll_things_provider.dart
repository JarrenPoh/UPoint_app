import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class ScrollByAnyDeviceScrollBehaviour extends MaterialScrollBehavior {
  const ScrollByAnyDeviceScrollBehaviour();

  @override
  Widget buildOverscrollIndicator(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;

  @override
  Set<PointerDeviceKind> get dragDevices => const {...PointerDeviceKind.values};
}

class CustomScrollProvider extends StatefulWidget {
  const CustomScrollProvider({
    super.key,
    required this.tabController,
    required this.parent,
    required this.child,
  });

  final TabController tabController;
  final ScrollController parent;
  final Widget child;

  @override
  State<CustomScrollProvider> createState() => CustomScrollProviderState();
}

class CustomScrollProviderState extends State<CustomScrollProvider> {
  late final List<CustomScrollController> scrollControllers;

  @override
  void initState() {
    super.initState();

    final activeIndex = widget.tabController.index;

    scrollControllers = List.generate(
      widget.tabController.length,
      (index) {
        return CustomScrollController(
          isActive: index == activeIndex,
          parent: widget.parent,
          debugLabel: 'CustomScrollController/$index',
        );

      },
    );

    // for (var i = 0; i < scrollControllers.length; i++) {
    //   final _scrollController = scrollControllers[i];
    //   _scrollController.addListenerToParent((offset, index,isActive) {
    //     // 在這裡處理滑動位移(offset)和當前是第幾個 CustomScrollController
    //     if(isActive){
    //       print('滑動位移：$offset，當前是第 $index 個 CustomScrollController');
    //     }
    //   }, i);
    // }

    widget.tabController.addListener(() {
      changeActiveIndex(widget.tabController.index);
    });
  }

  @override
  void dispose() {
    for (final scrollController in scrollControllers) {
      scrollController.dispose();
    }

    super.dispose();
  }

  void changeActiveIndex(int value) {
    for (var i = 0; i < scrollControllers.length; i++) {
      final scrollController = scrollControllers[i];
      final isActive = i == value;
      scrollController.isActive = isActive;

      if (isActive) {
        scrollController.forceAttach();
      } else {
        scrollController.forceDetach();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollProviderData(
      scrollControllers: scrollControllers,
      child: widget.child,
    );
  }
}

class CustomScrollProviderData extends InheritedWidget {
  const CustomScrollProviderData({
    super.key,
    required super.child,
    required this.scrollControllers,
  });

  static CustomScrollProviderData of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CustomScrollProviderData>()!;
  }

  final List<CustomScrollController> scrollControllers;

  @override
  bool updateShouldNotify(CustomScrollProviderData oldWidget) {
    return scrollControllers != oldWidget.scrollControllers;
  }
}

class CustomScrollController extends ScrollController {
  CustomScrollController({
    required this.isActive,
    required this.parent,
    String debugLabel = 'CustomScrollController',
  }) : super(
          debugLabel: parent.debugLabel == null
              ? null
              : '${parent.debugLabel}/$debugLabel',
          initialScrollOffset: parent.initialScrollOffset,
          keepScrollOffset: parent.keepScrollOffset,
        );

  bool isActive;
  final ScrollController parent;

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    debugPrint('$debugLabel-createScrollPosition: $isActive');

    return parent.createScrollPosition(physics, context, oldPosition);
  }

  // void addListenerToParent(Function(double, int,bool) listener, int index) {
    
  //   parent.addListener(() {
  //     listener(parent.offset, index,isActive);
  //   });
  // }

  @override
  void attach(ScrollPosition position) {
    debugPrint('$debugLabel-attach: $isActive');

    super.attach(position);
    if (isActive && !parent.positions.contains(position)) {
      parent.attach(position);
    }
  }

  @override
  void detach(ScrollPosition position) {
    debugPrint('$debugLabel-detach: $isActive');

    if (parent.positions.contains(position)) {
      parent.detach(position);
    }

    super.detach(position);
  }

  void forceDetach() {
    debugPrint('$debugLabel-forceDetach: $isActive');

    for (final position in positions) {
      if (parent.positions.contains(position)) {
        parent.detach(position);
      }
    }
  }

  void forceAttach() {
    debugPrint('$debugLabel-forceAttach: $isActive');

    for (final position in positions) {
      if (!parent.positions.contains(position)) {
        parent.attach(position);
      }
    }
  }

  @override
  void dispose() {
    debugPrint('$debugLabel-dispose: $isActive');

    forceDetach();
    super.dispose();
  }
}
