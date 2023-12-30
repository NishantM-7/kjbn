import 'dart:async';
import 'dart:io';

import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

enum Status { success, failed, timedOut }

class DataProvider with ChangeNotifier {
  // Obtain shared preferences.
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<void> fetchStoredData() async {
    final SharedPreferences prefs = await _prefs;
    _attempts = prefs.getInt('attempts') ?? 0;
    _success = prefs.getInt('success') ?? 0;
    notifyListeners();
  }

  Timer? _timer;
  Status _status = Status.success;
  static const _maxSec = 5;
  int _seconds = _maxSec;
  int _presentTime = 0;
  int _attempts = 0;
  int _success = 0;

  final random = Random();
  int _randomNumber = 0;

  Status get status {
    return _status;
  }

  int get attempts {
    return _attempts;
  }

  int get success {
    return _success;
  }

  int get randomNumber {
    return _randomNumber;
  }

  int get presentTime {
    return _presentTime;
  }

  bool get isRunning {
    return _timer == null ? false : _timer!.isActive;
  }

  int get seconds {
    return _seconds;
  }

  void timerUpdate() async {
    if (_seconds > 0) {
      _seconds--;
      notifyListeners();
    } else {
      _timer!.cancel();
      _status = Status.timedOut;
      _attempts++;
      _prefs.then((pref) async {
        await pref.setInt('attempts', _attempts);
      });
      notifyListeners();
    }
  }

  void onClickListen({bool clearAttempts = false}) async {
    if (clearAttempts) {
      _prefs.then((pref) async {
        _attempts = 0;
        _success = 0;
        await pref.setInt('attempts', 0);
        await pref.setInt('success', 0);
        notifyListeners();
      });
    } else {
      _attempts++;
      _randomNumber = 0 + random.nextInt(59 - 0 + 1);
      _presentTime = DateTime.now().second;
      if (_randomNumber == _presentTime) {
        _status = Status.success;
        _success++;
        _prefs.then((pref) async {
          await pref.setInt('attempts', _attempts);
          await pref.setInt('success', _success);
        });
      } else {
        _status = Status.failed;
      }
      if (!isRunning) {
        _seconds = _maxSec;
        _timer = Timer.periodic(Duration(seconds: 1), (_) {
          timerUpdate();
        });
      } else {
        _timer!.cancel();
        notifyListeners();
        _seconds = _maxSec;
        _timer = Timer.periodic(Duration(seconds: 1), (_) {
          timerUpdate();
        });
      }
    }
  }
}
