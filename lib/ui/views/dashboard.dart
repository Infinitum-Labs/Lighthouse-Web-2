part of views;

class Dashboard extends View {
  Dashboard({
    required Atmosphere atmosphere,
    Key? key,
  }) : super(atmosphere: atmosphere, key: key);
  @override
  ViewController<Dashboard> createState() => _DashboardVC();
}

class _DashboardVC extends ViewController<Dashboard> {
  late ToastController toastController;
  _DashboardVC() {
    toastController = ToastController(this);
    widget.atmosphere.viewController = this;
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
              widget.atmosphere,
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
