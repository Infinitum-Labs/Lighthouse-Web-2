part of ui.components;

class ViewConfigs {
  final dynamic debugConfigs;
  const ViewConfigs({this.debugConfigs});
}

abstract class View extends StatefulWidget {
  final ViewConfigs viewConfigs;
  final SatelliteStation satStation;
  const View(this.viewConfigs, this.satStation, {Key? key}) : super(key: key);

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
