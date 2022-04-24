import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

typedef EveryTestGoldenCallback = Future<void> Function(
  WidgetTester tester,
  dynamic parameter,
);

class EveryTestFinder {
  Finder finder;
  late dynamic value;
  late String golden;

  EveryTestFinder(this.finder);

  EveryTestFinder matches(dynamic param, String goldenFile) {
    value = param;
    golden = goldenFile;
    return this;
  }
}

EveryTestFinder finder(Finder any) => EveryTestFinder(any);

@isTestGroup
EveryTestGoldenBuilder everyTestGolden(
  String description, {
  required EveryTestGoldenCallback of,
  required List<EveryTestFinder> expects,
}) =>
    EveryTestGoldenBuilder(description)
      .._of(of)
      .._expects(expects)
      .._run();

class EveryTestGoldenBuilder {
  final String description;
  late EveryTestGoldenCallback _callback;
  late List<Finder> _finders;
  late List<dynamic> _params;
  late List<String> _expecteds;

  EveryTestGoldenBuilder(this.description);

  void _of(EveryTestGoldenCallback callback) {
    _callback = callback;
  }

  void _expects(List<EveryTestFinder> finders) {
    _finders = [];
    _params = [];
    _expecteds = [];
    for (var finder in finders) {
      _finders.add(finder.finder);
      _params.add(finder.value);
      _expecteds.add(finder.golden);
    }
  }

  void _run() {
    final findersIterator = _finders.iterator;
    final paramsIterator = _params.iterator;
    final expectedsIterator = _expecteds.iterator;

    while (findersIterator.moveNext() &&
        paramsIterator.moveNext() &&
        expectedsIterator.moveNext()) {
      var finder = findersIterator.current;
      var param = paramsIterator.current;
      var expected = expectedsIterator.current;
      testWidgets('$description($param)', (WidgetTester tester) async {
        await _callback(tester, param);
        await expectLater(finder, matchesGoldenFile(expected));
      });
    }
  }
}
