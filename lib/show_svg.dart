import 'package:flutter/material.dart';
import './map_svg_data.dart';

class ShowSvg extends StatefulWidget {
  @override
  _ShowSvgState createState() => _ShowSvgState();
}

class _ShowSvgState extends State<ShowSvg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Show SVG"),
      ),
      body: MyHomePage(),
    );
  }
}

///
/// Created by Giovanni Terlingen
/// See LICENSE file for more information.
///

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Province _pressedProvince;

  @override
  Widget build(BuildContext context) {
    /// Calculate the center point of the SVG map,
    /// use parent widget for width/heigth.
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double navBarHeight =
        Theme.of(context).platform == TargetPlatform.android ? 56.0 : 44.0;
    double safeZoneHeight = MediaQuery.of(context).padding.bottom;

    double scaleFactor = 0.5;

    double x = (width / 2.0) - (MapSvgData.width / 2.0);
    double y = (height / 2.0) -
        (MapSvgData.height / 2.0) -
        (safeZoneHeight / 2.0) -
        navBarHeight;
    Offset offset = Offset(x, y);

    return SafeArea(
        child: Transform.scale(
            scale: ((height / MapSvgData.height)) * scaleFactor,
            child: Transform.translate(
                offset: offset, child: Stack(children: _buildMap()))));
  }

  List<Widget> _buildMap() {
    List<Widget> provinces = List(Province.values.length);
    for (int i = 0; i < Province.values.length; i++) {
      provinces[i] = _buildProvince(Province.values[i]);
    }
    return provinces;
  }

  Widget _buildProvince(Province province) {
    return ClipPath(
        child: Stack(children: <Widget>[
          CustomPaint(painter: PathPainter(province)),
          Material(
              color: Colors.transparent,
              child: InkWell(
                  onTap: () => _provincePressed(province),
                  child: Container(
                      color: _pressedProvince == province
                          ? Color(0xFF7C7C7C)
                          : Colors.transparent)))
        ]),
        clipper: PathClipper(province));
  }

  void _provincePressed(Province province) {
    setState(() {
      _pressedProvince = province;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("massege"),
          actions: <Widget>[
            FlatButton(
              child: Text("yes"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class PathPainter extends CustomPainter {
  final Province _province;
  PathPainter(this._province);

  @override
  void paint(Canvas canvas, Size size) {
    Path path = getPathByProvince(_province);
    canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.black
          ..strokeWidth = 2.0);
  }

  @override
  bool shouldRepaint(PathPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(PathPainter oldDelegate) => false;
}

class PathClipper extends CustomClipper<Path> {
  final Province _province;
  PathClipper(this._province);

  @override
  Path getClip(Size size) {
    return getPathByProvince(_province);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
