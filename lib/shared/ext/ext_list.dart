extension ExtList on List? {
  List get validator => this ?? [];
  String get listToString {
    if (this == null) {
      return '';
    }
    this!.removeWhere(
      (element) => element == null || element == '',
    );
    return toString().replaceAll('[', '').replaceAll(']', '');
  }
}
extension ExtendList<T> on List<T> {
  void extend(int newLength, T defaultValue) {
    assert(newLength >= 0);

    final lengthDifference = newLength - this.length;
    if (lengthDifference <= 0) {
      return;
    }

    this.addAll(List.filled(lengthDifference, defaultValue));
  }
}
