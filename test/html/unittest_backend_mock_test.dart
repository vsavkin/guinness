library guinness.test.unittest_backend_mock_test;

import 'package:dartmocks/dartmocks.dart';
import 'package:guinness/guinness_html.dart' as guinness;
import 'package:unittest/unittest.dart';

import '../test_utils.dart';

assertTrue(Function fn) => expect(fn, returnsNormally);
assertFalse(Function fn) => expect(fn, throws);

class TestClass {
  var prop;

  TestClass([this.prop]);
}

class TestClassWithPrivateField {
  var prop;
  var _private;

  TestClassWithPrivateField([this.prop, this._private]);
}

void main() {
  group("[UnitTestVisitor]", () {
    var visitor, unit;

    setUp(() {
      unit = mock();
      visitor = new guinness.UnitTestVisitor(new Set(), unit: unit);
    });

    tearDown(currentTestRun.verify);

    test('handles an empty suite', () {
      visitor.visitSuite(createSuite());
    });

    test('uses group for describe', () {
      final suite = createSuite()..add(createDescribe());

      unit.shouldReceive("group");

      visitor.visitSuite(suite);
    });

    test('uses solo_group for exclusive describe', () {
      final suite = createSuite()..add(createDescribe(exclusive: true));

      unit.shouldReceive("solo_group");

      visitor.visitSuite(suite);
    });

    test('skips excluded describes', () {
      final suite = createSuite()..add(createDescribe(excluded: true));

      visitor.visitSuite(suite);
    });

    test('uses test for it', () {
      final suite = createSuite()..add(createIt());

      unit.shouldReceive("test");

      visitor.visitSuite(suite);
    });

    test('uses solo_test for exclusive it', () {
      final suite = createSuite()..add(createIt(exclusive: true));

      unit.shouldReceive("solo_test");

      visitor.visitSuite(suite);
    });

    test('skips excluded its', () {
      final suite = createSuite()..add(createIt(excluded: true));

      visitor.visitSuite(suite);
    });

    test('runs only exlusive its', () {
      final suite = createSuite()
        ..add(createIt(exclusive: true))
        ..add(createDescribe(exclusive: true));

      unit.shouldReceive("group");
      unit.shouldReceive("solo_test");

      visitor.visitSuite(suite);
    });

    test("initializes specs only once", () {
      final suite = createSuite()
        ..add(createIt())
        ..add(createDescribe());

      unit.shouldReceive("test").times(1);
      unit.shouldReceive("group").times(1);

      visitor.visitSuite(suite);

      visitor.visitSuite(suite);
    });
  });
}
