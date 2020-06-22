import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class DarkModeState extends Equatable {
  const DarkModeState();
}

class InitialDarkModeState extends DarkModeState {
  @override
  List<Object> get props => [];
}

class DarkModeChanged extends DarkModeState {
  final bool darkMode;

  const DarkModeChanged({@required this.darkMode});

  @override
  List<Object> get props => [darkMode];
}
