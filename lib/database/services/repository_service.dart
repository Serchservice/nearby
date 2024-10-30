import 'package:drive/library.dart';

/// Generic repository service providing CRUD operations for a data type [T].
///
/// Extend this class to implement specific repository functionalities.
class RepositoryService<T, K> {

  /// Creates or inserts the provided [item] into the database.
  ///
  /// Throws a [SerchException]. Extend this class to implement functionality in child classes.
  Future<T> save(T item) async {
    throw SerchException(
        "This is a superclass of repository. You should extend this class in its child classes."
    );
  }

  /// Reads data from the database.
  ///
  /// Throws a [SerchException]. Extend this class to implement functionality in child classes.
  T get() {
    throw SerchException(
        "This is a superclass of repository. You should extend this class in its child classes."
    );
  }

  /// Finds an item in the database by its [id].
  ///
  /// Throws a [SerchException]. Extend this class to implement functionality in child classes.
  Future<Optional<T>> findById(K id) async {
    throw SerchException(
        "This is a superclass of repository. You should extend this class in its child classes."
    );
  }

  /// Fetches all items from the database.
  ///
  /// Throws a [SerchException]. Extend this class to implement functionality in child classes.
  Future<List<T>> fetchAll() async {
    throw SerchException(
        "This is a superclass of repository. You should extend this class in its child classes."
    );
  }

  /// Deletes multiple items from the database.
  ///
  /// Throws a [SerchException]. Extend this class to implement functionality in child classes.
  Future<void> deleteAll(List<T> items) async {
    throw SerchException(
        "This is a superclass of repository. You should extend this class in its child classes."
    );
  }

  /// Deletes the provided [item] from the database.
  ///
  /// Throws a [SerchException]. Extend this class to implement functionality in child classes.
  Future<Optional<T>> delete(T item) async {
    throw SerchException(
        "This is a superclass of repository. You should extend this class in its child classes."
    );
  }
}