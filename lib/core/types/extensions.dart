part of core.types;

extension StringUtils on String {
  T parseTo<T>() {
    if (T == bool) {
      return (this == "true" ? true : false) as T;
    }
    if (T == DependencyRelation) {
      return DependencyRelation.values.firstWhere(
        (e) => e.toString() == this,
        orElse: () => throw TypeCastError(
            String, T, "Could not parse String to given type."),
      ) as T;
    } else if (T == Archetype) {
      return Archetype.values.firstWhere(
        (e) => e.toString() == this,
        orElse: () => throw TypeCastError(
            String, T, "Could not parse String to given type."),
      ) as T;
    } else if (T == TaskState) {
      return TaskState.values.firstWhere(
        (e) => e.toString() == this,
        orElse: () => throw TypeCastError(
            String, T, "Could not parse String to given type."),
      ) as T;
    } else if (T == AccessType) {
      return AccessType.values.firstWhere(
        (e) => e.toString() == this,
        orElse: () => throw TypeCastError(
            String, T, "Could not parse String to given type."),
      ) as T;
    } else {
      throw TypeCastError(String, T, "Could not parse String to given type.");
    }
  }
}
