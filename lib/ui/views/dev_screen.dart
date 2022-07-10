part of ui.views;

class DevScreen extends StatefulWidget {
  const DevScreen({Key? key}) : super(key: key);

  @override
  State<DevScreen> createState() => _DevScreenState();
}

class _DevScreenState extends State<DevScreen> {
  String anyMsg = '';
  bool loaded = false;
  late LighthouseObject obj;
  bool connectionSuccess = false;
  late Timer t;

  @override
  void initState() {
    super.initState();

    HttpClient.get(RequestObject(emptyRequestMap)).then((ResponseObject res) {
      setState(() {
        connectionSuccess = true;
        loaded = true;
        anyMsg = res.jsonData['payload']['msg'].toString();
      });

      t = Timer.periodic(const Duration(seconds: 2), (timer) {
        Vault.getAll().then((List<LighthouseObject> objects) {
          setState(() {
            anyMsg = objects
                .map((o) => "${o.objectId}: ${o.revisions}")
                .toList()
                .join('\n');
          });
        });
      });

      Future.delayed(const Duration(seconds: 3), () {
        final Workbench wb =
            Vault.create<Workbench>(Workbench(name: 'workable bench'));
        Future.delayed(const Duration(seconds: 2), () {
          wb.push('amazing #1', wb.projects);
          Future.delayed(const Duration(seconds: 2), () {
            Vault.update(
              wb.objectId,
              Workbench(name: 'name', projects: []),
            );
          });
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    t.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
      child: loaded ? Text(anyMsg) : const CircularProgressIndicator(),
    ));
  }
}
