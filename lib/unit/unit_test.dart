import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

/// Callback type used to call the test code
typedef EveryTestCallback = dynamic Function(
  dynamic parameter,
);

/// Symbolize a test parameter instance and its expected value
class EveryTestParameter {
  /// Parameter value (can be anything)
  dynamic value;

  /// Expected value for value parameter supplied
  dynamic expected;

  EveryTestParameter(this.value);

  /// method used to specify which value is expected for the specified parameter
  EveryTestParameter gives(dynamic expectedValue) {
    expected = expectedValue;
    return this;
  }
}

/// Util method used to instantiate a parameter instance
EveryTestParameter param(dynamic any) => EveryTestParameter(any);

/// Entry point to create a new 'everytest' series
/// Uses a builder to store every arguments before run the tests
@isTestGroup
EveryTestBuilder everyTest(
  String description, {
  required EveryTestCallback of,
  required List<EveryTestParameter> expects,
}) =>
    EveryTestBuilder(description)
      .._of(of)
      .._expects(expects)
      .._run();

/// Builder class handling every parameters in order to build and run tests
class EveryTestBuilder {
  /// Description of the test group
  final String description;

  /// Callback containing the test to run for each parameter value
  late EveryTestCallback _callback;

  /// List of parameters used to run tests
  /// Each parameter in the list will trigger a new test instance to run
  late List<dynamic> _params;

  /// Expected values for each parameter value
  /// Each expected value is compared to the result of each test instance
  late List<dynamic> _expecteds;

  EveryTestBuilder(this.description);

  /// Util method used to specify test callback to invoke during the test
  void _of(EveryTestCallback callback) {
    _callback = callback;
  }

  /// Util method used to specify each resul for every test instance
  ///   depending on the supplied parameters
  void _expects(List<EveryTestParameter> parameters) {
    _params = [];
    _expecteds = [];
    for (var parameter in parameters) {
      _params.add(parameter.value);
      _expecteds.add(parameter.expected);
    }
  }

  /// Perform a run of the callback in a test for every parameter
  ///   and compares the result to the expected value supplied
  void _run() {
    final paramsIterator = _params.iterator;
    final expectedsIterator = _expecteds.iterator;

    while (paramsIterator.moveNext() && expectedsIterator.moveNext()) {
      var param = paramsIterator.current;
      var expected = expectedsIterator.current;
      test('$description($param)', () {
        final actual = _callback(param);
        expect(actual, expected);
      });
    }
  }
}
