library guinness_test;

import 'package:guinness/guinness_html.dart' as guinness;
import 'package:unittest/unittest.dart';
import 'package:dartmocks/dartmocks.dart';
import 'dart:html' as html;
import 'dart:async';
import 'html_utils_test.dart' as htmlUtilsTest;

part 'src/syntax_test.dart';
part 'src/model_test.dart';
part 'src/spy_test.dart';
part 'src/integration_test.dart';
part 'src/exclusive_visitor_test.dart';
part 'src/unittest_backend_test.dart';
part 'src/suite_info_test.dart';

class DummyContext implements guinness.Context {
  withDescribe(guinness.Describe describe, Function definition) {}
}

final context = new DummyContext();
noop() {}

createSuite() => new guinness.Suite(context);

createDescribe({bool exclusive: false, bool excluded: false, parent,
    Function func: noop, String name: ""}) => new guinness.Describe(
    name, parent, context, func, exclusive: exclusive, excluded: excluded);

createIt({bool exclusive: false, bool excluded: false, parent,
    Function func: noop, String name: ""}) => new guinness.It(
    name, parent, func, exclusive: exclusive, excluded: excluded);

main() {
  guinness.guinnessEnableHtmlMatchers();
  guinness.guinness.autoInit = false;

  testIntegration();
  testExclusiveVisitor();
  testSuiteInfo();
  testSyntax();
  testModel();
  testSpy();
  testUnitTestBackend();

  htmlUtilsTest.main();
}
