part of ui.components;

abstract class View extends StatefulWidget {
  const View({Key? key}) : super(key: key);

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
