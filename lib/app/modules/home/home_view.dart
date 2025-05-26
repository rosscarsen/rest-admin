import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_grid/responsive_grid.dart';

import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('HomeView')),

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              _buildTestButtonItem(context, _buildGridLayout(), "Responsive Grid Rows"),
              _buildTestButtonItem(
                context,
                _buildGridLayout_testCrossAlign(),
                "Responsive Grid Rows (crossAxisAlignment)",
              ),
              _buildTestButtonItem(context, _buildGridList(), "Responsive Grid List"),
              _buildTestButtonItem(context, _buildGridList_rowMainAxisAlign(), "Grid List (rowMainAxisAlignment)"),
              _buildTestButtonItem(context, _buildGridList_variableItemsHeights(), "variable items heights"),
              _buildTestButtonItem(context, _buildStaggeredGridList(), "StaggeredGridList"),
              _buildTestButtonItem(context, _resposiveWidgetTest(), "ResponsiveWidget"),
              _buildTestButtonItem(context, _resposiveValueTest(context), "responsiveValue method"),
              _buildTestButtonItem(context, _resposiveBuilderTest(), "ResponsiveBuilder"),
              _buildTestButtonItem(context, _buildResponsiveLocalWidget(), "ResponsiveLocalWidget"),
            ],
          ),
        ),
      ),
    );
  }

  // region widgets creation methods

  Widget _buildTestButtonItem(BuildContext context, Widget widget, String name) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExamplePage(title: name, child: widget)),
            ),
        child: Text(name),
      ),
    );
  }

  Widget _buildGridList() {
    return ResponsiveGridList(
      desiredItemWidth: 100,
      minSpacing: 10,
      children:
          [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20].map((i) {
            return Container(
              height: 100.0,
              alignment: const Alignment(0, 0),
              color: Colors.cyan,
              child: Text(i.toString()),
            );
          }).toList(),
    );
  }

  Widget _buildGridLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ResponsiveGridRow(
          children: [
            ResponsiveGridCol(
              lg: 12,
              child: Container(
                height: 100,
                alignment: const Alignment(0, 0),
                color: Colors.purple,
                child: const Text("lg : 12"),
              ),
            ),
            ResponsiveGridCol(
              xs: 6,
              md: 3,
              child: Container(
                height: 100,
                alignment: const Alignment(0, 0),
                color: Colors.green,
                child: const Text("xs : 6 \r\nmd : 3"),
              ),
            ),
            ResponsiveGridCol(
              xs: 6,
              md: 3,
              child: Container(
                height: 100,
                alignment: const Alignment(0, 0),
                color: Colors.orange,
                child: const Text("xs : 6 \r\nmd : 3"),
              ),
            ),
            ResponsiveGridCol(
              xs: 6,
              md: 3,
              child: Container(
                height: 100,
                alignment: const Alignment(0, 0),
                color: Colors.red,
                child: const Text("xs : 6 \r\nmd : 3"),
              ),
            ),
            ResponsiveGridCol(
              xs: 6,
              md: 3,
              child: Container(
                height: 100,
                alignment: const Alignment(0, 0),
                color: Colors.blue,
                child: const Text("xs : 6 \r\nmd : 3"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGridList_rowMainAxisAlign() {
    return ResponsiveGridList(
      rowMainAxisAlignment: MainAxisAlignment.center,
      desiredItemWidth: 100,
      minSpacing: 10,
      children:
          [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20].map((i) {
            return Container(
              height: 100.0,
              alignment: const Alignment(0, 0),
              color: Colors.cyan,
              child: Text(i.toString()),
            );
          }).toList(),
    );
  }

  Widget _buildGridList_variableItemsHeights() {
    return ResponsiveGridList(
      rowMainAxisAlignment: MainAxisAlignment.center,
      desiredItemWidth: 100,
      minSpacing: 10,
      children:
          [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20].map((i) {
            return Container(
              height: ((i % 5) + 1) * 100.0,
              alignment: const Alignment(0, 0),
              color: Colors.cyan,
              child: Text(i.toString()),
            );
          }).toList(),
    );
  }

  Widget _buildGridLayout_testCrossAlign() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ResponsiveGridRow(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ResponsiveGridCol(
              xs: 6,
              child: Column(
                children: [
                  Container(height: 100, color: Colors.blue, margin: const EdgeInsets.all(10)), // height 100px
                  Container(height: 100, color: Colors.blueGrey, margin: const EdgeInsets.all(10)), // height 100px
                ],
              ),
            ),
            ResponsiveGridCol(
              xs: 6,
              child: Container(height: 220, color: Colors.black45, margin: const EdgeInsets.all(10)), // height 500px
            ),
          ],
        ),
      ],
    );
  }

  Widget _resposiveWidgetTest() {
    return Center(
      child: const ResponsiveWidget(xs: Text('xs'), sm: Text('sm'), md: Text('md'), lg: Text('lg'), xl: Text('xl')),
    );
  }

  Widget _resposiveValueTest(BuildContext context) {
    return Center(child: Text(responsiveValue(context, xs: 'xs', lg: 'lg', md: 'md', sm: 'sm', xl: 'xl')));
  }

  Widget _resposiveBuilderTest() {
    return Center(
      child: ResponsiveBuilder(
        child: const Text('child', style: TextStyle(fontSize: 30)),
        xs: (_, child) => Container(alignment: Alignment.topRight, child: child),
        sm: (_, child) => Container(alignment: Alignment.topLeft, child: child),
      ),
    );
  }

  Widget _buildStaggeredGridList() {
    return ResponsiveStaggeredGridList(
      desiredItemWidth: 100,
      minSpacing: 10,
      children:
          [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20].map((i) {
            return Container(
              height: ((i % 3) + 1) * 100.0,
              alignment: const Alignment(0, 0),
              color: Colors.cyan,
              child: Text(i.toString()),
            );
          }).toList(),
    );
  }

  Widget _buildResponsiveLocalWidget() {
    return ResponsiveLocalWidget(
      configs:
          [500, 600, 700, 900]
              .map((e) => ResponsiveWidgetConfig(upToWidth: e.toDouble(), child: Center(child: Text(e.toString()))))
              .toList(),
    );
  }

  // endregion
}

class ExamplePage extends StatelessWidget {
  final Widget child;
  final String title;

  const ExamplePage({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(title)), body: child);
  }
}
