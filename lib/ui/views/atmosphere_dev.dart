part of views;

/** TWO WAYS THE ATMOSPHERE CAN BE IMPLEMENTED
 * class MyScreen
    Atmosphere(
        Button(
          onPress: showToast(data)                        // polymorphism >> doesnt work as child widgets are passed around in constructors, without access to 
          onPress: Atmosphere.of(context).showToast(data) // inheritedWidget
 */

class Atmosphere extends StatefulWidget {
  final Widget child;
  const Atmosphere({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  State<Atmosphere> createState() => _AtmosphereState();
}

class _AtmosphereState extends State<Atmosphere> {
  final List<Toast> toasts = [];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          widget.child,
          if (toasts.isNotEmpty)
            Positioned(
              left: -340,
              top: 0,
              child: toasts.first,
            ),
        ],
      ),
    );
  }
}

class Atmosphere2 extends InheritedWidget {
  Toast? toast;

  Atmosphere2({
    Key? key,
  }) : super(child: const EmptyWidget(), key: key);

  static Atmosphere2? of(BuildContext context) {
    final Atmosphere2? result =
        context.dependOnInheritedWidgetOfExactType<Atmosphere2>();
    return result;
  }

  void showToast(Toast toast) {
    this.toast = toast;
  }

  @override
  bool updateShouldNotify(Atmosphere2 old) => true;
}

class Atmosphere3 extends StatefulWidget {
  final Component child;

  Atmosphere3({required this.child, Key? key}) : super(key: key);

  @override
  State<Atmosphere3> createState() => _Atmosphere3State();
}

class _Atmosphere3State extends State<Atmosphere3> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [widget.child.build(context)],
    );
  }
}

abstract class Component {
  Widget build(BuildContext context);
}

class BigRed extends Component {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 100,
      child: Text("WELCOME"),
      color: Colors.green,
    );
  }
}

/* abstract class ViewController<View> extends State {
  final List<Toast> toasts = [];
}

abstract class View1 extends StatefulWidget {
  final List<Toast> toasts = [];
  final Widget child;

  View1({required this.child, Key? key}) : super(key: key);
}

class MyScreen extends View {
  final Widget child;
  MyScreen({required this.child, Key? key}) : super(child: child, key: key);
  @override
  ViewController<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends ViewController<MyScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Stack(
            children: [
              widget.child,
              CustomTB(viewController: this),
              if (widget.toasts.isNotEmpty)
                Positioned(
                  left: -340,
                  top: 0,
                  child: widget.toasts.first,
                ),
            ],
          ),
        ),
      ),
    );
  }
}


 */