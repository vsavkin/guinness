library guinness_test;

import 'package:guinness/guinness.dart' as guinness;
import 'package:unittest/unittest.dart';
import 'dart:html' as html;
import 'html_utils_test.dart' as htmlUtilsTest;

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

  htmlUtilsTest.main();
}