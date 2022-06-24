/// Represents a group of [Platform]s.
enum PlatformGroup {
  mobile,
  desktop;

  /// Returns the [Platform]s that belong to this.
  List<Platform> get platforms {
    switch (this) {
      case PlatformGroup.mobile:
        return [Platform.android, Platform.ios];
      case PlatformGroup.desktop:
        return [Platform.linux, Platform.macos, Platform.windows];
    }
  }
}

/// The platform a Scalable project might support.
enum Platform {
  android,
  ios,
  web,
  linux,
  macos,
  windows;

  /// Returns a pretty string representation of this.
  String get prettyName {
    switch (this) {
      case Platform.android:
        return 'Android';
      case Platform.ios:
        return 'iOS';
      case Platform.web:
        return 'Web';
      case Platform.macos:
        return 'macOS';
      case Platform.linux:
        return 'Linux';
      case Platform.windows:
        return 'Windows';
    }
  }
}

extension PlatformListX on List<Platform> {
  /// Returns a pretty string representation of this.
  ///
  /// ```dart
  /// <Platform>[].prettyEnumeration // -> null
  /// [Platform.ios].prettyEnumeration // -> "iOS"
  /// [Platform.ios, Platform.android].prettyEnumeration // -> "iOS and Android"
  /// [Platform.ios, Platform.android, Platform.windows].prettyEnumeration // -> "iOS, Android and Windows"
  /// ```
  String? get prettyEnumeration {
    if (isEmpty) {
      return null;
    }

    if (length == 1) {
      return first.prettyName;
    }

    if (length == 2) {
      return '${first.prettyName} and ${last.prettyName}';
    }

    final head = take(length - 2).map((e) => e.prettyName).join(', ');
    final tail = [this[length - 2].prettyName, last.prettyName].join(' and ');

    return [head, tail].join(', ');
  }
}
