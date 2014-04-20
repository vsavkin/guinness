library jasmine;

import 'package:unittest/unittest.dart' as unit;
import 'package:collection/equality.dart';
import 'dart:async' as async;
import 'dart:html';
import 'src/html_utils.dart' as htmlUtils;

part 'src/model.dart';
part 'src/syntax.dart';
part 'src/matchers.dart';
part 'src/spy.dart';
part 'src/interfaces.dart';

// use the unittest library to run the tests
part 'src/unittest_backend/unittest_backend.dart';

Context context = new Context(runner: unitTestRunner, matchers: new UnitTestMatchers());