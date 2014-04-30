library guinness_html;

import 'guinness.dart' as gns;
import 'package:unittest/unittest.dart' as unit;
import 'src/html_utils.dart' as htmlUtils;

export 'guinness.dart';

part 'src/html/interfaces.dart';
part 'src/html/expect.dart';
part 'src/html/syntax.dart';
part 'src/html/unittest_html_matchers.dart';

void guinnessEnableHtmlMatchers(){
  gns.guinness.matchers = new UnitTestMatchersWithHtml();
}