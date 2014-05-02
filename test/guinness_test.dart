library guinness_test;

import 'package:guinness/guinness_html.dart' as guinness;
import 'package:unittest/unittest.dart';
import 'package:dartmocks/dartmocks.dart';
import 'dart:html' as html;
import 'html_utils_test.dart' as htmlUtilsTest;

part 'src/syntax_test.dart';
part 'src/model_test.dart';
part 'src/spy_test.dart';
part 'src/integration_test.dart';
part 'src/unittest_backend_test.dart';


class DummyContext implements guinness.Context {
  withDescribe(guinness.Describe describe, Function definition){
  }
}

final context = new DummyContext();
final noop = (){};


createSuite() => new guinness.Suite(context);

createDescribe({bool exclusive: false, bool excluded: false, parent}) =>
    new guinness.Describe("", parent, context, noop, exclusive: exclusive, excluded: excluded);

createIt({bool exclusive: false, bool excluded: false, parent}) =>
    new guinness.It("", parent, noop, exclusive: exclusive, excluded: excluded);



main(){
  guinness.guinnessEnableHtmlMatchers();
  guinness.guinness.autoInit = false;

  testIntegration();
  testSyntax();
  testModel();
  testSpy();
  testUnitTestBackend();

  htmlUtilsTest.main();
}