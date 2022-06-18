part of views;

abstract class View extends StatefulWidget {
  final Widget child;

  View({required this.child, Key? key}) : super(key: key);

  @override
  ViewController createState();
}

abstract class ViewController<T extends View> extends State<T> {
  Toast? toast;
  @override
  Widget build(BuildContext context);
}

class Dashboard extends View {
  Dashboard({required Widget child, Key? key}) : super(child: child, key: key);
  @override
  ViewController<Dashboard> createState() => _DashboardVC();
}

class _DashboardVC extends ViewController<Dashboard> {
  late ToastController toastController;
  _DashboardVC() {
    toastController = ToastController(this);
  }

  @override
  Widget build(BuildContext context) {
    toastController.clearToastQueue();
    return Material(
      child: Center(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Stack(
            children: [
              widget.child,
              CustomTB(toastController: toastController),
              if (toastController.toastQueue.isNotEmpty)
                Positioned(
                  left: -340,
                  top: 0,
                  child: Toast(
                    toastController.toastQueue.first,
                    key: UniqueKey(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTB extends StatelessWidget {
  final ToastController toastController;

  CustomTB({required this.toastController});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        toastController.addToQueue(
          ToastData(
            title: "Title",
            description: "description",
            logType: LogType.log,
          ),
        );
      },
      child: const Text("CustomTB"),
    );
  }
}

class ToastController {
  final List<ToastData> toastQueue = [];
  final ViewController viewController;

  ToastController(this.viewController);

  void addToQueue(ToastData toastData) {
    viewController.setState(() {
      toastQueue.add(toastData);
    });
  }

  void clearToastQueue() {
    toastQueue.removeWhere((ToastData t) => t.hasBeenShown == true);
  }
}
