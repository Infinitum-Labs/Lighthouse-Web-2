part of ui;

class DevScreen extends StatelessWidget {
  DevScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Center(
          child: TextButton(
            child: Text('eh'),
            onPressed: () {
              return null;
            },
          ),
        ),
      ),
    );
  }
}
