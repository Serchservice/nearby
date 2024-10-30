import 'package:drive/library.dart';

class Optional<T> {
  final T? _value;
  final List<T> _values;

  /// Private constructor for internal use.
  const Optional._internal(this._value, this._values);

  /// Creates an empty Optional.
  factory Optional.empty() {
    return const Optional._internal(null, []);
  }

  /// Creates an Optional with a non-null value.
  ///
  /// Throws a [SerchException] if [value] is null.
  factory Optional.of(T value) {
    if (value == null) {
      throw SerchException("$T cannot be null");
    }
    return Optional._internal(value, []);
  }

  /// Creates an Optional with a list of values.
  ///
  /// Throws a [SerchException] if [values] is empty.
  factory Optional.ofList(List<T> values) {
    if (values.isEmpty) {
      throw SerchException("$values cannot be null or empty");
    }
    return Optional._internal(null as T, values);
  }

  /// Creates an Optional with a nullable value.
  factory Optional.ofNullable(T value) {
    return Optional._internal(value, []);
  }

  /// Retrieves the value if present, otherwise throws a [SerchException].
  T get() {
    if (_value == null) {
      throw SerchException('$T is not present');
    }
    return _value;
  }

  /// Checks if the Optional contains a value.
  bool isPresent() {
    return _value != null;
  }

  /// Executes a consumer function if a value is present.
  void ifPresent(void Function(T value) consumer) {
    if (isPresent()) {
      consumer(_value as T);
    }
  }

  /// Executes a consumer function for each value in the list.
  void ifPresentInList(void Function(T value) consumer) {
    _values.forEach(consumer);
  }

  /// Filters the Optional based on a predicate.
  Optional<T> filter(bool Function(T value) predicate) {
    return isPresent() && predicate(_value as T) ? this : Optional.empty();
  }

  /// Maps the value to a list of type U.
  List<U> mapToList<U>(U Function(T value) mapper) {
    return _values.map(mapper).toList();
  }

  /// Filters the list based on a predicate.
  List<T> filterList(bool Function(T value) predicate) {
    return _values.where(predicate).toList();
  }

  /// Maps the value to another Optional type U.
  Optional<U> map<U>(U Function(T value) mapper) {
    return isPresent() ? Optional.ofNullable(mapper(_value as T)) : Optional.empty();
  }

  /// Maps the value to another Optional type U using a mapper function that returns an Optional.
  Optional<U> flatMap<U>(Optional<U> Function(T value) mapper) {
    return isPresent() ? mapper(_value as T) : Optional.empty();
  }

  /// Returns the value if present, otherwise returns [other].
  T orElse(T other) {
    return _value ?? other;
  }

  /// Returns the value if present, otherwise calls [other] to get a default value.
  T orElseGet(T Function() other) {
    return _value ?? other();
  }

  /// Returns the value if present, otherwise throws an exception provided by [exceptionSupplier].
  T orElseThrow(Object Function() exceptionSupplier) {
    if (isPresent()) {
      return _value!;
    } else {
      throw exceptionSupplier();
    }
  }

  /// Executes an if-present callback, otherwise executes an else callback.
  void ifPresentOrElse(void Function(T value) ifPresentCallback, void Function() elseCallback) {
    if (_value != null) {
      ifPresentCallback(_value);
    } else {
      elseCallback();
    }
  }

  /// Executes an if-present callback for each value in the list, otherwise executes an else callback.
  void ifPresentInListOrElse(void Function(T value) ifPresentCallback, void Function() elseCallback) {
    if (_values.isNotEmpty) {
      _values.forEach(ifPresentCallback);
    } else {
      elseCallback();
    }
  }

  /// Returns the first item in the list that matches the condition.
  ///
  /// Throws a [SerchException] if no matching item is found.
  T firstIf(bool Function(T value) condition) {
    if (_values.isNotEmpty) {
      for (var item in _values) {
        if (condition(item)) {
          return item;
        }
      }
    }
    throw SerchException("$condition item is not in list");
  }

  /// Checks equality between this Optional and another object.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Optional &&
              runtimeType == other.runtimeType &&
              (_value == other._value || (_value != null && _value == other._value));

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() {
    return isPresent() ? 'Optional[$_value]' : 'Optional.empty';
  }
}