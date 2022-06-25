part of ui.views;

class DevScreen extends StatefulWidget {
  final String objectId;
  const DevScreen(this.objectId, {Key? key}) : super(key: key);

  @override
  State<DevScreen> createState() => _DevScreenState();
}

class _DevScreenState extends State<DevScreen> {
  bool loaded = false;
  late LighthouseObject obj;

  @override
  void initState() {
    super.initState();
    Vault.get(widget.objectId).then(
      (value) => setState(() {
        obj = value;
        loaded = true;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: loaded
          ? Text(obj.json.toString())
          : const CircularProgressIndicator(),
    );
  }
}
