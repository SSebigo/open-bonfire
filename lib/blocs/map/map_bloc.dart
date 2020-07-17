import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bonfire/models/bonfire.dart';
import 'package:bonfire/repositories/bonfire_repository.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import './bloc.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final Logger logger = Logger();

  Geolocator geolocator = Geolocator();
  final LocationOptions _locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 25);

  StreamSubscription<Position> _positionStream;
  StreamSubscription<List<Bonfire>> _bonfireSubscription;
  final BonfireRepository _bonfireRepository = BonfireRepository();

  final LocalStorageRepository _localStorageRepository = LocalStorageRepository();

  MapBloc() : super(InitialMapState());

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is OnFetchInitialPositionEvent) {
      final GeolocationStatus geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
      if (geolocationStatus == GeolocationStatus.granted) {
        final Position position =
            await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);

        yield FetchedInitialPositionState(position: position);
      }
    }
    if (event is OnFetchPositionEvent) {
      yield* _mapFetchPositionToState();
    }
    if (event is OnReceivedPositionEvent) {
      yield FetchedPositionState(position: event.position);
    }
    if (event is OnFetchBonfiresEvent) {
      yield* _mapFetchBonfiresEventToState(event);
    }
    if (event is OnReceivedBonfiresEvent) {
      yield* _mapReceivedBonfiresEventToState(event);
    }
    if (event is OnLightBonfireClickedEvent) {
      yield* _mapOnLightBonfireEventToState(event);
    }
    if (event is OnBonfireClickedEvent) {
      yield* _mapOnBonfireClickedEventToState(event);
    }
  }

  Stream<MapState> _mapFetchPositionToState() async* {
    try {
      _positionStream?.cancel();
      _positionStream = geolocator
          .getPositionStream(_locationOptions)
          .listen((Position position) => add(OnReceivedPositionEvent(position: position)));
    } catch (error) {
      yield MapErrorState(error: error);
    }
  }

  Stream<MapState> _mapFetchBonfiresEventToState(OnFetchBonfiresEvent event) async* {
    yield FetchingBonfiresState();
    try {
      Position position;

      if (event.position == null) {
        final GeolocationStatus geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
        if (geolocationStatus == GeolocationStatus.granted) {
          position = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
        }
      } else {
        position = event.position;
      }

      _bonfireSubscription?.cancel();
      _bonfireSubscription = _bonfireRepository
          .getBonfires(position, 0.05)
          .listen((bonfires) => add(OnReceivedBonfiresEvent(bonfires: bonfires)));
    } catch (error) {
      yield MapErrorState(error: error);
    }
  }

  Stream<MapState> _mapReceivedBonfiresEventToState(OnReceivedBonfiresEvent event) async* {
    try {
      final int now = DateTime.now().millisecondsSinceEpoch;
      event.bonfires.forEach((bonfire) {
        if (bonfire.expiresAt <= now) {
          bonfire.expired = true;
          _bonfireRepository?.updateBonfireExpiration(bonfire.id);
        }
      });
      event.bonfires.removeWhere((bonfire) => bonfire.expired);
      yield FetchedBonfiresState(bonfires: event.bonfires);
    } catch (error) {
      yield MapErrorState(error: error);
    }
  }

  Stream<MapState> _mapOnLightBonfireEventToState(OnLightBonfireClickedEvent event) async* {
    yield NavigatingState();
    switch (event.type) {
      case 0:
        yield NavigationToLightBonfireFileState();
        break;
      case 1:
        yield NavigationToLightBonfireImageState();
        break;
      case 2:
        yield NavigationToLightBonfireVideoState();
        break;
      case 3:
        yield NavigationToLightBonfireTextState();
        break;
      // case 4:
      //   yield ARComingState();
      //   break;
      default:
    }
  }

  Stream<MapState> _mapOnBonfireClickedEventToState(OnBonfireClickedEvent event) async* {
    yield SittingByTheFireState();
    try {
      if (!event.bonfire.viewedBy.contains(_localStorageRepository.getUserSessionData(Constants.sessionUsername))) {
        final List<String> viewedBy = List<String>.from(event.bonfire.viewedBy);

        viewedBy.add(_localStorageRepository?.getUserSessionData(Constants.sessionUsername) as String);
        await _bonfireRepository?.updateBonfireViewedBy(event.bonfire.id, viewedBy);

        event.bonfire.viewedBy = List<String>.from(viewedBy);
      }
      yield NavigateToBonfireState(bonfire: event.bonfire);
    } catch (error) {
      yield MapErrorState(error: error);
    }
  }
}
