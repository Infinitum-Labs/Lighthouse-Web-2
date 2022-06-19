part of ui.components;

/// [`FoundationColor`](https://github.com) refers to the core brand colors of Lighthouse,
/// which are named according to the [IDS Color Palette Naming Format](https://github.com).
class FoundationColor {
  /// The darkest shade of blue, extremely close to black
  static Color get blue100 => const Color(0xFF00101E);
}

/// [`SemanticColor`](https://github.com) refers to the semantic colors of Lighthouse,
/// which are named according to the [IDS Color Palette Naming Format](https://github.com).
class SemanticColor {
  /// A creamy white with a hint of yellow, similar to that of creme paper
  static Color get white => const Color(0xFFFFF8DD);

  /// A bright, forest green. Indicates a positive response.
  static Color get green => const Color(0xFF2AB250);

  /// A light, mango yellow. Indicates a warning.
  static Color get yellow => const Color(0xFFFFD16F);

  /// A hot pink. Indicates a negative response.
  static Color get pink => const Color(0xFFD94084);
}
