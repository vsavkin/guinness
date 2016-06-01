library guinness_test;

import 'package:guinness/guinness_html.dart' as guinness;

import 'common_test.dart' as common;
import 'html/html_utils_test.dart' as htmlUtilsTest;
import 'html/unittest_backend_test.dart' as unittest_backend;
import 'html/unittest_backend_mock_test.dart' as unittest_mock_backend;

void main() {
  guinness.guinnessEnableHtmlMatchers();
  guinness.guinness.autoInit = false;

  common.main();
  htmlUtilsTest.main();
  unittest_backend.main();
  unittest_mock_backend.main();
}
