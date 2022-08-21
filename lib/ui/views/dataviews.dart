part of ui.views;

class DataView extends View {
  const DataView(
    ViewConfigs viewConfigs,
    SatelliteStation satStation, {
    Key? key,
  }) : super(viewConfigs, satStation, key: key);
  @override
  ViewController<DataView> createState() => _DataViewVC();
}

class _DataViewVC extends ViewController<DataView> {
  dynamic grid1 = {};
  dynamic grid2 = {};
  dynamic grid3 = {};
  dynamic grid4 = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Atmosphere(
      viewController: this,
      lithosphere: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: <Widget>[
          Column(
            children: [
              TextButton(
                onPressed: () {
                  HttpClient.get_session(RequestObject(emptyRequestMap))
                      .then((ResponseObject res) {
                    setState(() {
                      grid1 = res.jsonData;
                    });
                  }).catchError((Object err) {
                    setState(() {
                      if (err is ProgressEvent) {}
                      grid1 = {'errx': err.toString()};
                    });
                  });
                  /* HttpClient.get_x(RequestObject(emptyRequestMap)
                        ..setPayload({
                          'username': 'JOGN',
                          'password': 'bapple',
                        }))
                      .then((ResponseObject res) {
                    setState(() {
                      grid1 = res.jsonData;
                    });
                  }).catchError((Object err) {
                    setState(() {
                      if (err is ProgressEvent) {}
                      grid1 = {'err1': err.toString()};
                    });
                  }); */
                  /* HttpClient.get_x(RequestObject(emptyRequestMap)
                        ..setPayload({
                          'username': 'JOGN',
                          'password': 'bapple',
                        }))
                      .then((dynamic res) {
                    setState(() {
                      grid1 = res.toString();
                    });
                  }).catchError(
                    (Object o) {
                      if (o is DBError) {
                        setState(() {
                          grid1 = {
                            'status': o.statusCode,
                            'msg': o.msg,
                            'requet': o.request,
                          };
                        });
                      } else {
                        Map x = {'err': o};
                        if (o is Error) x.addAll({'trace': o.stackTrace});
                        if (o is ProgressEvent) x.addAll({'info': o.loaded});
                        setState(() {
                          grid1 = x;
                        });
                      }
                    },
                  ); */
                },
                child: const Text("1"),
              ),
              SingleChildScrollView(
                child: Text(grid1.toString()),
              ),
            ],
          ),
          Column(
            children: [
              TextButton(
                onPressed: () {
                  HttpClient.get(RequestObject(emptyRequestMap))
                      .then((ResponseObject res) {
                    setState(() {
                      grid2 = res.jsonData;
                      //anyMsg = res.jsonData['payload']['msg'].toString();
                    });
                  });
                },
                child: const Text("2"),
              ),
              SingleChildScrollView(
                child: Text(grid2.toString()),
              ),
            ],
          ),
          Column(
            children: [
              TextButton(
                onPressed: () {
                  HttpClient.get_test(RequestObject(emptyRequestMap))
                      .then((ResponseObject response) {
                    setState(() {
                      grid3 = response.jsonData;
                    });
                  }).catchError((o) {
                    grid3 = {'e': o};
                  });
                },
                child: const Text("3"),
              ),
              SingleChildScrollView(
                child: Text(grid3.toString()),
              ),
            ],
          ),
          Column(
            children: [
              TextButton(
                onPressed: () {
                  HttpClient.get_session(
                    RequestObject(emptyRequestMap)
                      ..setPayload({
                        'username': 'JOGN',
                        'password': 'bapple',
                      }),
                  ).then((ResponseObject res) {
                    setState(() {
                      grid1 = res.jsonData;
                    });
                  }).catchError(
                    (Object o) {
                      if (o is DBError) {
                        setState(() {
                          grid1 = {
                            'status': o.statusCode,
                            'msg': o.msg,
                            'requet': o.request,
                          };
                        });
                      } else {
                        setState(() {
                          grid1 = {'err': o};
                        });
                      }
                    },
                  );
                },
                child: const Text("4"),
              ),
              SingleChildScrollView(
                child: Text(grid4.toString()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
