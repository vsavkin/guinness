library jasmine_syntax_test;

import 'package:jasmine_dart/jasmine.dart' as jasmine;
import 'package:unittest/unittest.dart';

part 'src/syntax_test.dart';
part 'src/model_test.dart';
part 'src/spy_test.dart';
part 'src/integration_test.dart';

main(){
  testIntegration();
  testSyntax();
  testModel();
  testSpy();
}