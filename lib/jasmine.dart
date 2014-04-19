library jasmine;

import 'package:unittest/unittest.dart' as unit;
import 'dart:async' as async;

part 'src/model.dart';
part 'src/syntax.dart';
part 'src/matchers.dart';
part 'src/spy.dart';

// use the unittest library to run the tests
part 'src/unittest_backend/unittest_backend.dart';


abstract class SpecVisitor {
  void visitSuite(Suite suite);
  void visitDescribe(Describe describe);
  void visitIt(It it);
}

abstract class Matchers {
  void expectToEqual(actual, expected);
}

Context context = new Context(runner: unitTestRunner, matchers: new UnitTestMatchers());