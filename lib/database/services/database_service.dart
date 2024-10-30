/// Abstract class to define the base structure for a database service that handles
/// reading, writing, and removing data from a storage system.
abstract class DatabaseService {

  /// Writes a value to the database under the specified key.
  /// 
  /// @param key The key under which the value will be stored.
  /// @param value The value to be stored.
  /// 
  /// @return A `Future` that completes when the write operation is finished.
  Future<void> write(String key, dynamic value);

  /// Reads a value from the database for the specified key.
  /// 
  /// @param <T> The type of the value expected to be read.
  /// @param key The key whose value will be read.
  /// 
  /// @return The value read from the database, or `null` if the key does not exist.
  T? read<T>(String key);

  /// Erases all data from the database.
  /// 
  /// @return A `Future` that completes when the erase operation is finished.
  Future<void> erase();

  /// Removes the value associated with the specified key from the database.
  /// 
  /// @param key The key whose value will be removed.
  /// 
  /// @return A `Future` that completes when the remove operation is finished.
  Future<void> remove(String key);
}