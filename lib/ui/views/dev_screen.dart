part of ui.views;

class DevScreen extends StatefulWidget {
  final String objectId;
  const DevScreen(this.objectId, {Key? key}) : super(key: key);

  @override
  State<DevScreen> createState() => _DevScreenState();
}

class _DevScreenState extends State<DevScreen> {
  String anyMsg = '';
  bool loaded = false;
  late LighthouseObject obj;
  bool connectionSuccess = false;

  @override
  void initState() {
    super.initState();

    HttpClient.get(RequestObject(emptyRequestMap)).then((ResponseObject res) {
      setState(() {
        connectionSuccess = true;
        loaded = true;
        anyMsg = res.jsonData.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
      child: loaded
          ? Text(connectionSuccess.toString() + anyMsg)
          : const CircularProgressIndicator(),
    ));
  }
}
