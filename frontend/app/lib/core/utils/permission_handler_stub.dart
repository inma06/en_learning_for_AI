// 웹 환경에서 사용할 permission_handler의 스텁 구현
class Permission {
  static Future<PermissionStatus> get microphone =>
      Future.value(PermissionStatus.granted);
  static Future<PermissionStatus> get speech =>
      Future.value(PermissionStatus.granted);
  static Future<PermissionStatus> get camera =>
      Future.value(PermissionStatus.granted);
  static Future<PermissionStatus> get photos =>
      Future.value(PermissionStatus.granted);
  static Future<PermissionStatus> get location =>
      Future.value(PermissionStatus.granted);

  Future<PermissionStatus> request() => Future.value(PermissionStatus.granted);
  Future<PermissionStatus> get status => Future.value(PermissionStatus.granted);
}

class PermissionStatus {
  static const granted = PermissionStatus._(0);
  static const denied = PermissionStatus._(1);
  static const permanentlyDenied = PermissionStatus._(2);

  final int _value;
  const PermissionStatus._(this._value);

  bool get isGranted => _value == 0;
  bool get isDenied => _value == 1;
  bool get isPermanentlyDenied => _value == 2;
}

Future<bool> openAppSettings() async => true;
