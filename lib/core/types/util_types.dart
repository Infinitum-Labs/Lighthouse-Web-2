part of core.types;

/// No way I'm using `Map<String, dynamic>` for the entire project.
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
