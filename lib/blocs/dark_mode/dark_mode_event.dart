import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class DarkModeEvent extends Equatable {
  const DarkModeEvent();
}

class OnDarkModeToggled extends DarkModeEvent {
  final bool darkMode;

  const OnDarkModeToggled({@required this.darkMode});

  @override
  List<Object> get props => [darkMode];
}