part of ui.views;

class LaunchScreen extends View {
  const LaunchScreen(ViewConfigs viewConfigs, {Key? key})
      : super(viewConfigs, key: key);
  @override
  ViewController<LaunchScreen> createState() => _LaunchScreenVC();
}

class _LaunchScreenVC extends ViewController<LaunchScreen> {
  late String response;
  bool dataImportTriggered = false;
  bool loading = false;
  late String username;
  late String password;

  @override
  Widget build(BuildContext context) {
    if (loading && !dataImportTriggered) {
      dataImportTriggered = true;
      widget.viewConfigs.debugConfigs?.logger.log('Preparing to fetch');
      HttpClient.get(
        RequestObject(emptyRequestMap)
          ..setSlug(Slug.auth)
          ..setJwtString('NONE')
          ..setPayload({
            'username': username,
            'password': password,
          }),
      ).then((ResponseObject responseObject) {
        widget.viewConfigs.debugConfigs?.logger.log('received response');
        widget.viewConfigs.debugConfigs?.logger.log(responseObject.jsonData);
        setState(() {
          response = responseObject.toString();
          widget.viewConfigs.debugConfigs?.logger.log(response);
          loading = false;
        });
      });
    }
    toastController.refresh();
    return Atmosphere(
      viewController: this,
      lithosphere: Stack(
        alignment: Alignment.center,
        children: [
          if (!loading && !dataImportTriggered)
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
              child: Text('Launching app... as\n$username\n$password'),
            ),
          if (!loading && dataImportTriggered)
            Center(
              child: Text(response),
            ),
        ],
      ),
    );
  }
}
