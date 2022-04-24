class SampleRepository {
  List<int> values = [];

  double get average =>
      values.reduce((value, element) => value + element) / values.length;
}
