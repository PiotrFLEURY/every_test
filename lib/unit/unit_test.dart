import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

typedef EveryTestCallback = dynamic Function(
  dynamic parameter,
);

class EveryTestParameter {
  dynamic value;
  dynamic expected;

  EveryTestParameter(this.value);

  EveryTestParameter gives(dynamic expectedValue) {
    expected = expectedValue;
    return this;
  }
}

EveryTestParameter param(dynamic any) => EveryTestParameter(any);

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

class EveryTestBuilder {
  final String description;
  late EveryTestCallback _callback;
  late List<dynamic> _params;
  late List<dynamic> _expecteds;

  EveryTestBuilder(this.description);

  void _of(EveryTestCallback callback) {
    _callback = callback;
  }

  void _expects(List<EveryTestParameter> parameters) {
    _params = [];
    _expecteds = [];
    for (var parameter in parameters) {
      _params.add(parameter.value);
      _expecteds.add(parameter.expected);
    }
  }

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
