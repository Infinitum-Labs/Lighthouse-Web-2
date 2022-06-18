part of components;

abstract class View extends StatefulWidget {
  final Atmosphere atmosphere;

  const View({required this.atmosphere, Key? key}) : super(key: key);

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
