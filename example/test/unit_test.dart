import 'package:every_test/every_test.dart';
import 'package:example/domain/sample_repository.dart';
import 'package:example/domain/translations_repository.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test('sample test', () {
    // GIVEN
    final repository = SampleRepository();
    repository.values.addAll([1, 2, 3]);

    // WHEN
    final result = repository.average;

    // THEN
    expect(result, 2);
  });

  everyTest(
    'Expected average values computation',
    of: (param) {
      final repository = SampleRepository();
      repository.values = param;
      return repository.average;
    },
    expects: [
      param([1, 2, 3]).gives(2),
      param([4, 5, 6]).gives(5),
      param([7, 8, 9]).gives(8),
      param([9, 9, 9]).gives(9),
    ],
  );

  everyTest(
    'translation test',
    of: (params) {
      // GIVEN
      final locale = params['locale'];
      final key = params['key'];
      final repository = TranslationsRepository(currentLocale: locale);

      // WHEN
      return repository.translate(key);
    },
    expects: [
      // THEN
      param({'locale': 'en', 'key': 'app_name'}).gives('sample'),
      param({'locale': 'fr', 'key': 'app_name'}).gives('exemple'),
      param({'locale': 'es', 'key': 'app_name'}).gives('sample'),
      param({'locale': 'en', 'key': 'hello'}).gives('!hello!'),
    ],
  );
}
