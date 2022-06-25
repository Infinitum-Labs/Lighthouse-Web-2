part of core.types;

extension StringUtils on String {
  bool parseBool() => this == "true" ? true : false;
}
