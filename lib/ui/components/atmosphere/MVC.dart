part of ui.components;

class ViewConfigs {
  final DebugConfigs? debugConfigs;
  const ViewConfigs({this.debugConfigs});
}

abstract class View extends StatefulWidget {
  final ViewConfigs viewConfigs;
  const View(this.viewConfigs, {Key? key}) : super(key: key);

  @override
  ViewController createState();
}

abstract class ViewController<T extends View> extends State<T> {
  late ToastController toastController;

  ViewController() {
    toastController = ToastController(this);
  }

  @override
  Widget build(BuildContext context);
}
