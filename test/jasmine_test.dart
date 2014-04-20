library jasmine_test;

import 'package:jasmine_dart/jasmine.dart' as jasmine;
import 'package:unittest/unittest.dart';
import 'dart:html' as html;

part 'src/syntax_test.dart';
part 'src/model_test.dart';
part 'src/spy_test.dart';
part 'src/integration_test.dart';
part 'src/unittest_backend/unittest_backend_test.dart';

main(){
  testIntegration();
  testSyntax();
  testModel();
  testSpy();
  testUnitTestBackend();
}