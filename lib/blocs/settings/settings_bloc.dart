import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:bonfire/repositories/authentication_repository.dart';
import 'package:bonfire/repositories/local_storage_repository.dart';
import 'package:bonfire/repositories/user_data_repository.dart';
import 'package:bonfire/utils/constants.dart';
import 'package:bonfire/utils/exceptions.dart';
import 'package:bonfire/utils/validators.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:password/password.dart';
import './bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AuthenticationRepository _authenticationRepository = AuthenticationRepository();
  final UserDataRepository _userDataRepository = UserDataRepository();
  final LocalStorageRepository _localStorageRepository = LocalStorageRepository();

  SettingsBloc() : super(InitialSettingsState());

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is OnNameChanged) {
      yield TextFieldChangedState();
      yield NameValidityState(isNameValid: Validators.name(event.name));
    }
    if (event is OnEmailChanged) {
      yield TextFieldChangedState();
      yield EmailValidityState(isEmailValid: Validators.email(event.email));
    }
    if (event is OnPasswordChanged) {
      yield TextFieldChangedState();
      yield PasswordValidityState(isPasswordValid: Validators.password(event.password));
    }
    if (event is OnModifyNameClicked) {
      yield* _mapOnModifyNameClickedToState(event);
    }
    if (event is OnModifyEmailClicked) {
      yield* _mapOnModifyEmailClickedToState(event);
    }
    if (event is OnModifyPasswordClicked) {
      yield* _mapOnModifyPasswordClickedToState(event);
    }
    if (event is OnReportProblemClicked) {
      yield* _mapOnReportProblemClickedToState(event);
    }
    if (event is OnGiveFeedbackClicked) {
      yield* _mapOnGiveFeedbackClickedToState(event);
    }
    if (event is OnLogoutClicked) {
      yield* _mapOnLogoutClickedToState();
    }
  }

  Stream<SettingsState> _mapOnModifyNameClickedToState(OnModifyNameClicked event) async* {
    yield ModifyingFieldState();
    try {
      if (event.password.isEmpty ||
          !Password.verify(
            event.password,
            _localStorageRepository?.getUserSessionData(Constants.sessionPassword) as String,
          )) {
        throw InvalidPasswordException(event.errorMessage);
      } else {
        await _userDataRepository?.updateName(event.name);
        yield FieldModifiedState();
      }
    } catch (error) {
      yield SettingsFailedState(error: error);
    }
  }

  Stream<SettingsState> _mapOnModifyEmailClickedToState(OnModifyEmailClicked event) async* {
    yield ModifyingFieldState();
    try {
      if (event.password.isEmpty ||
          !Password.verify(
            event.password,
            _localStorageRepository?.getUserSessionData(Constants.sessionPassword) as String,
          )) {
        throw InvalidPasswordException(event.errorMessage);
      } else {
        await _authenticationRepository.updateEmail(event.email.trim());
        yield FieldModifiedState();
      }
    } catch (error) {
      yield SettingsFailedState(error: error);
    }
  }

  Stream<SettingsState> _mapOnModifyPasswordClickedToState(OnModifyPasswordClicked event) async* {
    yield ModifyingFieldState();
    try {
      if (event.currentPassword.isEmpty ||
          !Password.verify(
            event.currentPassword,
            _localStorageRepository?.getUserSessionData(Constants.sessionPassword) as String,
          )) {
        throw InvalidPasswordException(event.errorMessage);
      } else {
        await _authenticationRepository?.updatePassword(event.newPassword);
        yield FieldModifiedState();
      }
    } catch (error) {
      yield SettingsFailedState(error: error);
    }
  }

  Stream<SettingsState> _mapOnReportProblemClickedToState(OnReportProblemClicked event) async* {
    yield ReportingProblemState();
    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      final Map<String, dynamic> deviceData = Platform.isAndroid
          ? _readAndroidBuildData(await deviceInfo.androidInfo)
          : _readIosDeviceInfo(await deviceInfo.iosInfo);

      final String os = Platform.isAndroid ? 'Android' : 'IOS';

      final String body = 'User: ${_localStorageRepository?.getUserSessionData(Constants.sessionUsername)}\n'
          'OS version: $os ${deviceData['version.release']}\n'
          'Sdk version: ${deviceData['version.sdkInt'].toString()}\n'
          'Manufacturer: ${deviceData['manufacturer'] ?? 'unknown'}\n'
          'Device: ${deviceData['brand']}\n'
          'Device model: ${deviceData['model']}\n\n'
          'Details: ${event.body}\n';

      final Email email = Email(
        recipients: ['bonfire.sebigo@gmail.com'],
        subject: 'Bonfire bug report! ⚠️',
        body: body,
        isHTML: false,
      );

      await FlutterEmailSender.send(email);

      yield ProblemReportedState();
    } catch (error) {
      yield SettingsFailedState(error: error);
    }
  }

  Stream<SettingsState> _mapOnGiveFeedbackClickedToState(OnGiveFeedbackClicked event) async* {
    yield GivingFeedbackState();
    try {
      final String os = Platform.isAndroid ? 'Android' : 'IOS';

      final String body = 'User: ${_localStorageRepository?.getUserSessionData(Constants.sessionUsername)}\n'
          'OS: $os\n\n'
          'Details: ${event.body}\n';

      final Email email = Email(
        recipients: ['bonfire.sebigo@gmail.com'],
        subject: 'Bonfire user feedback! ❤️',
        body: body,
        isHTML: false,
      );

      await FlutterEmailSender.send(email);

      yield FeedbackGivenState();
    } catch (error) {
      yield SettingsFailedState(error: error);
    }
  }

  Stream<SettingsState> _mapOnLogoutClickedToState() async* {
    yield LoggingOutState();
    try {
      await _authenticationRepository?.signOut();
      yield LoggedOutState();
    } catch (error) {
      yield SettingsFailedState(error: error);
    }
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }
}
