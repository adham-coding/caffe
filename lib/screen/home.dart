import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as ws;
import 'package:window_manager/window_manager.dart';
import 'package:toastification/toastification.dart';
import 'package:caffe/components/blur_box.dart';
import 'package:caffe/components/layout/right.dart';
import 'package:caffe/components/pop_up.dart';
import 'package:caffe/constants/colors.dart';
import 'package:caffe/components/layout/left_bottom.dart';
import 'package:caffe/components/layout/left_middle.dart';
import 'package:caffe/components/layout/left_top.dart';
import 'package:caffe/models/refresher.dart';
import 'package:caffe/components/layout/header.dart';
import 'package:caffe/models/purchase.dart';
import 'package:caffe/constants/sizes.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WindowListener {
  final TextEditingController _screenController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Refresher _refresher = Refresher();
  final List<Purchase> _purchases = [];
  final ws.Socket _socket =
      ws.io("https://cafe-ws.onrender.com", <String, dynamic>{
    "transports": ["websocket"],
    "autoConnect": false,
  });
  List<dynamic> _screens = [];
  String _screen = "";
  bool _isOnline = false;

  @override
  void initState() {
    super.initState();

    windowManager.addListener(this);

    _socket.onConnect((_) {
      _socket.on("purchases", (data) {
        try {
          List<Purchase> purchases = List.generate(
            data.length,
            (i) => Purchase.fromMap(data[i]),
          );

          for (Purchase purchase in purchases) {
            int i = _purchases.indexWhere((Purchase p) => p.id == purchase.id);

            if (i < 0) {
              if (purchase.quantity > 0) _purchases.add(purchase);
            } else {
              _purchases[i].quantity += purchase.quantity;

              if (_purchases[i].quantity < 1) _purchases.removeAt(i);
            }
          }

          _socket.emit("purchases", "🟢 RECEIVED : ${_socket.id}");

          _refresher.refresh();
        } catch (e) {
          _socket.emit("purchases", "🔴 ERROR : $e");
        }

        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const Center(
        //     child: CircularProgressIndicator(
        //       strokeWidth: 3.5,
        //       valueColor: AlwaysStoppedAnimation(borderColor),
        //     ),
        //   ); // Display a loading indicator when waiting for data.
        // } else if (snapshot.hasData) {
        // } else if (snapshot.hasError) {
        //   return const Center(child: Text("Error!"));
        // } else {
        //   return const Center(child: Text("No purchases"));
        // }
      });

      _socket.on("clear", (_) {
        try {
          _purchases.clear();

          _socket.emit("purchases", "🟢 CLEARED : ${_socket.id}");

          _refresher.refresh();
        } catch (e) {
          _socket.emit("error", "🔴 ERROR : $e");
        }
      });

      _socket.on("screen", (data) {
        try {
          if (data["error"] != null) {
            toastification.show(
              context: context,
              title: const Text("ERROR!"),
              description: Text(data["error"]),
              autoCloseDuration: const Duration(seconds: 5),
              alignment: Alignment.topCenter,
              type: ToastificationType.error,
              backgroundColor: const Color.fromARGB(255, 100, 0, 0),
            );
          } else if (data["success"] != null) {
            _screen = _screenController.text;
            _passwordController.text = "";

            toastification.show(
              context: context,
              title: const Text("SUCCESS!"),
              description: Text('Your screen name is "$_screen"'),
              autoCloseDuration: const Duration(seconds: 2),
              alignment: Alignment.topCenter,
              type: ToastificationType.success,
              backgroundColor: const Color.fromARGB(255, 0, 100, 0),
            );
          } else {
            _screens = data["screens"];
          }

          setState(() {});
        } catch (e) {
          _socket.emit("error", "🔴 ERROR : $e");
        }
      });

      setState(() {
        _isOnline = true;
      });
    });

    _socket.onDisconnect((_) {
      for (var event in ["purchases", "clear", "screen"]) {
        _socket.off(event);
      }

      setState(() {
        _screen = "";
        _screens = [];
        _isOnline = false;
      });
    });

    _socket.connect();
  }

  @override
  Widget build(BuildContext context) {
    double dHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/assets/images/coffee.webp"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(gap),
            child: Column(
              children: <Widget>[
                Header(isOnline: _isOnline, screen: _screen),
                Expanded(
                  child: _screen.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BlurBox(
                              width: 350.0,
                              margin: const EdgeInsets.only(bottom: gap),
                              padding: const EdgeInsets.all(gap * 1.25),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  TextField(
                                    autofocus: true,
                                    textAlign: TextAlign.center,
                                    controller: _screenController,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: const InputDecoration(
                                      hintText: "Screen name",
                                      hintStyle: textStyle,
                                      contentPadding: EdgeInsets.all(0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(borderRadius),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: gap),
                                  TextField(
                                    autofocus: true,
                                    obscureText: true,
                                    textAlign: TextAlign.center,
                                    controller: _passwordController,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: const InputDecoration(
                                      hintText: "Password",
                                      hintStyle: textStyle,
                                      contentPadding: EdgeInsets.all(0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(borderRadius),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: gap),
                                  OutlinedButton(
                                    onPressed: () => _socket.emit(
                                      "screen",
                                      {
                                        "screen": _screenController.text,
                                        "password": _passwordController.text,
                                      },
                                    ),
                                    style: buttonStyle,
                                    child: const Text("Enter"),
                                  ),
                                ],
                              ),
                            ),
                            BlurBox(
                              width: 350.0,
                              height: dHeight < 700.0 ? dHeight - 350.0 : 350.0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: gap * 1.25,
                                vertical: gap,
                              ),
                              child: Column(
                                children: [
                                  const Text("Screens"),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: _screens.length,
                                      itemBuilder: (context, i) => PopUp(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: gap / 2,
                                            vertical: gap,
                                          ),
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                width: 1.0,
                                                color: borderColor,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            _screens[i],
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: gap / 2),
                                child: Column(
                                  children: <Widget>[
                                    const LeftTop(),
                                    LeftMiddle(
                                      refresher: _refresher,
                                      purchases: _purchases,
                                    ),
                                    LeftBottom(
                                      refresher: _refresher,
                                      purchases: _purchases,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Right(),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onWindowClose() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.brown.shade800,
          title: const Text(
            'Are you sure to exit?',
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: buttonStyle,
                    child: const Text('No'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: gap * 1.5),
                Expanded(
                  child: OutlinedButton(
                    style: buttonStyle,
                    child: const Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      windowManager.destroy();
                    },
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _socket.close();

    super.dispose();
  }
}
