class SocketEvents {
  SocketEvents._();

  static const booking = _BookingEvents();
  static const place = _PlaceEvents();
  static const availability = _AvailabilityEvents();
}

class _BookingEvents {
  const _BookingEvents();

  final String created = 'booking:created';
  final String cancelled = 'booking:cancelled';
  final String extended = 'booking:extended';
  final String completed = 'booking:completed';
  final String activated = 'booking:activated';
  final String updated = 'booking:updated';
}

class _PlaceEvents {
  const _PlaceEvents();

  final String created = 'place:created';
  final String updated = 'place:updated';
  final String deleted = 'place:deleted';
}

class _AvailabilityEvents {
  const _AvailabilityEvents();

  final String updated = 'availability:updated';
}
