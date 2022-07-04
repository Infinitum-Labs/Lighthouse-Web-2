part of core.utils.communication;

abstract class Satellite {
  const Satellite();

  void deinit();
}

class CommunicationSatellite extends Satellite {
  const CommunicationSatellite() : super();

  @override
  void deinit() {}
}

class ObservatorySatellite extends Satellite {
  const ObservatorySatellite() : super();

  @override
  void deinit() {}
}

class SatelliteStation {
  final CommunicationSatellite commSat;
  final ObservatorySatellite obsSat;

  const SatelliteStation(this.commSat, this.obsSat);
}
