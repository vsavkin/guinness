library jasmine;

import 'package:unittest/unittest.dart' as unit;
import 'dart:async' as async;

part 'src/model.dart';
part 'src/syntax.dart';
part 'src/matchers.dart';

// use the unittest library to run the tests
part 'src/unittest_backend/unittest_backend.dart';

Context context = new Context(runner: unitTestRunner, matchers: new UnitTestMatchers());