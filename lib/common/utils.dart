Future<void> delay(Duration duration) => Future<void>.delayed(duration);

Map<K, V> mergedMaps<K, V>(Map<K, V> x, Map<K, V> y) {
  var result = Map.of(x);
  if (y != null) {
    result.addAll(y);
  }
  return result;
}
