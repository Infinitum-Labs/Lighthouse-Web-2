library core.engines.context;

part './contextEngine.dart';

class Context {
  final String location;
  final ConstrainedNum energyLevel;
  final Duration timeAvailable;
  final Resources resources;

  Context(
    this.location,
    this.energyLevel,
    this.timeAvailable,
    this.resources,
  );
}

class ContextRequirement {
  final List<String> locations;
  final ConstrainedNum energyLevel;
  final Duration timeNeeded;
  final Resources resourcesNeeded;
  final Weightage weightage;

  ContextRequirement(
    this.locations,
    this.energyLevel,
    this.timeNeeded,
    this.resourcesNeeded,
    this.weightage,
  );
}

class ConstrainedNum {
  final double lowerBound;
  final double upperBound;

  ConstrainedNum(this.lowerBound, this.upperBound);
}

/// Either a list of [Resource]s, or a [ResourceSet]
class Resources {
  final List<Resource>? _resources;
  final ResourceSet? _resourceSet;

  Resources(this._resources, this._resourceSet) {
    if (_resources == null && _resourceSet == null) {
      throw Error();
    }
  }

  List<Resource> getAll() =>
      _resources == null ? _resourceSet!.resources : _resources!;
}

class Resource {
  final String name;
  Resource(this.name);
}

class ResourceSet {
  final String name;
  final List<Resource> resources;

  ResourceSet(this.name, this.resources);
}

class Weightage {
  final double location;
  final double energyLevel;
  final double time;
  final double resources;

  Weightage(this.location, this.energyLevel, this.time, this.resources);
}
