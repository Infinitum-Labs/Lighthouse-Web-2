part of ui;

class CommandLineView extends StatefulWidget {
  @override
  _CommandLineViewState createState() => _CommandLineViewState();
}

class _CommandLineViewState extends State<CommandLineView> {
  WizResult wizResult = WizResult(LogType.log, '');
  final List<String> history = [];
  final textController = TextEditingController();
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    focusNode.requestFocus();
    return Material(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey,
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 350,
              color: Colors.black,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List<Widget>.generate(history.length, (int i) {
                    return Text(
                      history[i],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.purple,
                      ),
                    );
                  }),
                ),
              ),
            ), // Logs
            Container(
              width: double.infinity,
              height: 50,
              color: Colors.lightGreen,
              child: Text(
                wizResult.msg,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            Container(
              width: double.infinity,
              height: 60,
              color: Colors.purple,
              child: TextField(
                textInputAction: TextInputAction.go,
                controller: textController,
                focusNode: focusNode,
                onSubmitted: ((String? value) {
                  if (value != null) {
                    history.add(value);
                    WizEngine.handle(value).then((WizResult result) =>
                        setState(() => wizResult = result));
                  }
                  textController.clear();
                  focusNode.requestFocus();
                  setState(() {});
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
