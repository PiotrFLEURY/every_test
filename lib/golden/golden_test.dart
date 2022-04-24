import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

/// Callback type used to call the test code
typedef EveryTestGoldenCallback = Future<void> Function(
  WidgetTester tester,
  dynamic parameter,
);

/// Symbolize a golden test finder, its parameter instance and its expected value
class EveryTestFinder {
  /// Finder used to compare Widget with golden record
  Finder finder;

  /// Parameter value (can be anything)
  late dynamic value;

  /// Golden file name used as reference to compare with Widget
  late String golden;

  EveryTestFinder(this.finder);

  /// Util method used to store param and golden file name
  EveryTestFinder matches(dynamic param, String goldenFile) {
    value = param;
    golden = goldenFile;
    return this;
  }
}

/// Util method used to instantiate a new Finder with the corresponding parameter
EveryTestFinder finder(Finder any) => EveryTestFinder(any);

/// Entry point to create a new 'everyTestGloden' series
/// Uses a builder to store every arguments before run the tests
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

/// Builder class handling every parameters in order to build and run tests
class EveryTestGoldenBuilder {
  /// Description of the test group
  final String description;

  /// Callback containing the test to run for each parameter value
  late EveryTestGoldenCallback _callback;

  /// List of finders used to match with golden
  late List<Finder> _finders;

  /// List of parameters used to run tests
  /// Each parameter in the list will trigger a new test instance to run
  late List<dynamic> _params;

  /// Expected values for each parameter value
  /// Each expected value is compared to the result of each test instance
  late List<String> _expecteds;

  EveryTestGoldenBuilder(this.description);

  /// Util method used to specify test callback to invoke during the test
  void _of(EveryTestGoldenCallback callback) {
    _callback = callback;
  }

  /// Util method used to specify each resul for every test instance
  ///   depending on the supplied parameters
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

  /// Perform a run of the callback in a test for every parameter
  ///   and compares the result to the expected value supplied
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
