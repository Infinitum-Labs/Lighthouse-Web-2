part of core.types;

/// A typedef for `Map<String, Object?>`
typedef JSON = Map<String, dynamic>;

/// `LogType` represents a semantic status of either:
/// - `log`: A normal informative message
///   - green
/// - `warn`: A warning message
///   - orange
/// - `err`: An error message
///   - red
enum LogType {
  log,
  warn,
  err,
}
