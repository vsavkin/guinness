library guinness.test.common_tests;

import 'package:guinness/guinness.dart';
import 'package:unittest/unittest.dart';

import 'common/exclusive_visitor_test.dart' as exclusive_visitor;
import 'common/integration_test.dart' as integration;
import 'common/model_test.dart' as model;
import 'common/spy_test.dart' as spy;
import 'common/suite_info_test.dart' as suite_info;
import 'common/syntax_test.dart' as syntax;

void main() {
  guinness.autoInit = false;

  group("[ExclusiveVisitor]", exclusive_visitor.main);
  group("[integration]", integration.main);
  group('[model]', model.main);
  spy.main();
  group('[suiteInfo]', suite_info.main);
  group('[syntax]', syntax.main);
}
