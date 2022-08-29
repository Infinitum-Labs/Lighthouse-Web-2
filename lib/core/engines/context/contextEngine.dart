part of core.engines.context;

class ContextEngine {
  final ContextEngineConfiguration configuration;

  ContextEngine(this.configuration);

  double match(ContextRequirement requirement, Context context) {
    double conformity = 0;

    if (requirement.locations.contains(context.location)) {
      conformity += requirement.weightage.location * 1;
    }

    if (requirement.energyLevel.lowerBound < context.energyLevel.lowerBound &&
        requirement.energyLevel.upperBound > context.energyLevel.upperBound) {
      conformity += requirement.weightage.energyLevel * 1;
    } // add more cases to handle deviations

    if (requirement.timeNeeded < context.timeAvailable) {
      conformity += requirement.weightage.time * 1;
    } else {
      conformity += requirement.weightage.time *
          (context.timeAvailable.inMinutes / requirement.timeNeeded.inMinutes);
    }

    final List<String> resourcesNeeded =
        requirement.resourcesNeeded.getAll().map((e) => e.name).toList();
    final List<String> resourcesAvailable =
        context.resources.getAll().map((e) => e.name).toList();
    resourcesNeeded.removeWhere(resourcesAvailable.contains);

    conformity += ((requirement.resourcesNeeded.getAll().length -
                resourcesNeeded.length) /
            (requirement.resourcesNeeded.getAll().length)) *
        requirement.weightage.resources;

    return conformity;
  }
}

class ContextEngineConfiguration {}
