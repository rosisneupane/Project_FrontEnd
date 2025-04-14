import 'package:new_ui/model/user.dart';

class UserService {
  static final UserService _instance = UserService._internal();

  factory UserService() => _instance;

  UserService._internal();

  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
  }
}