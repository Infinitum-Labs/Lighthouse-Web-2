part of ui.components;

class Toast extends StatefulWidget {
  final ToastData toastData;
  bool hasBeenShown = false;
  Toast(this.toastData, {Key? key}) : super(key: key);

  @override
  State<Toast> createState() => _ToastState();
}

class _ToastState extends State<Toast> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 600),
    vsync: this,
  );

  late final Animation<Offset> offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.2, 0.0),
  ).animate(
    CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    ),
  );

  @override
  void initState() {
    super.initState();
    show();
  }

  void show() {
    widget.hasBeenShown = true;
    controller.forward();
    Timer(const Duration(seconds: 3), () {
      hide();
    });
  }

  void hide() {
    controller.reverse();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: offsetAnimation,
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: 340,
          height: 120,
          decoration: BoxDecoration(
            color: SemanticColor.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                width: double.infinity,
                height: 7,
                child: Container(
                  decoration: BoxDecoration(
                    color: SemanticColor.green,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 7,
                left: 0,
                height: 63,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 17, 20, 33),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: "Task Completed Successfully"),
                        TextSpan(
                            text:
                                "Pellentesque viverra eleifend eget feugiat mauris ut. Ac maecenas nunc lacinia congue eget ac. Vitae lorem tellus sed lorem sit a malesuada rutrum et")
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
