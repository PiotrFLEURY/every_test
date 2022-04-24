<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

# Every Test

Write and execute multiple combination of the same test with less code with every_test package.

## Features

* Write unit test with various parameter values

* Write golden tests with various finders and parameters

## Getting started

```shell
flutter pub add --dev every_test
```

## Usage

### Simple unit test

Start by calling `everyTest` method in any `*_test.dart` file

```dart
main() {
    everyTest(/***/);
}
```

Then give it a description

```dart
everyTest(
    'my first everyTest test',
    ...
);
```

Give it the test itself using parameter

```dart
...
'my first everyTest test',
of: (param) {
    final repository = SampleRepository();
    repository.values = param;
    return repository.average;
},
...    
```

Last but not least, give it the list of expected results depending on parameter using `param(foo).gives(bar)` syntax

```dart
...
of: (param) {
    ...
},
expects: [
    param([1, 2, 3]).gives(2),
],
...
```

Then add as many combination as wanted and voilà !

```dart
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
```

### Using several parameters a time

You may need to send multiple parameters for test execution. Just use Json syntax. That's it.

```dart
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
      param({'locale': 'en', 'key': 'app_name'}).gives('sample'), // en translation
      param({'locale': 'fr', 'key': 'app_name'}).gives('exemple'), // fr translation
      param({'locale': 'es', 'key': 'app_name'}).gives('sample'), // default translation
      param({'locale': 'en', 'key': 'hello'}).gives('!hello!'), // not found translation
    ],
  );
```

### Golden tests

```dart
 everyTestGolden(
    'every test golden',
    of: (tester, color) async {
      await tester.pumpWidget(MyApp(primarySwatch: color));
    },
    expects: [
      finder(find.byType(MyApp)).matches(Colors.blue, 'goldens/blue.png'),
      finder(find.byType(MyApp)).matches(Colors.red, 'goldens/red.png'),
      finder(find.byType(MyApp)).matches(Colors.green, 'goldens/green.png'),
    ],
  );
```