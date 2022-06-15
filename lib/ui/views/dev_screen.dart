part of views;

class DevScreen extends StatelessWidget {
  DevScreen({Key? key}) : super(key: key);
  bool hasToast = false;

  @override
  Widget build(BuildContext context) {
    return Atmosphere(
      lithosphere: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: FoundationColor.blue100,
          child: Stack(
            children: [
              Center(
                child: TextButton(
                  child: const Text('eh'),
                  onPressed: () {
                    hasToast = true;
                  },
                ),
              ),
              if (hasToast) const Toast(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Alrighty, buckle up for a little Geography lesson.
/// An `Atmosphere` contains [Atmospheric Components](https://github.com) like `Toast`s, the `Sidebar`, etc.
/// These components exist on every page, "hovering" over the [Lithospheric Components](https://github.com) in a way.
class Atmosphere extends StatefulWidget {
  final Widget lithosphere;
  Atmosphere({
    required this.lithosphere,
  });

  @override
  _AtmosphereState createState() => _AtmosphereState();
}

class _AtmosphereState extends State<Atmosphere> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: FoundationColor.blue100,
            ),
          ),
        ),
        widget.lithosphere,
      ],
    );
  }
}
