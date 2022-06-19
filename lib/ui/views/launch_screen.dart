part of ui.views;

class LaunchScreen extends View {
  const LaunchScreen({Key? key}) : super(key: key);
  @override
  ViewController<LaunchScreen> createState() => _LaunchScreenVC();
}

class _LaunchScreenVC extends ViewController<LaunchScreen> {
  bool dataImportTriggered = false;
  bool loading = false;
  late String username;
  late String password;

  @override
  Widget build(BuildContext context) {
    if (loading && !dataImportTriggered) {
      HttpClient();
    }
    toastController.refresh();
    return Atmosphere(
      viewController: this,
      lithosphere: Stack(
        alignment: Alignment.center,
        children: [
          if (!loading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    autofocus: true,
                    onSubmitted: (String value) {
                      username = value;
                    },
                  ),
                  TextField(
                    onSubmitted: (String value) {
                      password = value;
                      setState(() {
                        loading = true;
                      });
                    },
                  ),
                ],
              ),
            ),
          if (loading)
            Center(
              child: Text(
                'Launching app... as\n$username\n$password',
              ),
            ),
        ],
      ),
    );
  }
}
