library guinness.test.exclusive_visitor_test;

import 'package:guinness/guinness.dart' as guinness;
import 'package:unittest/unittest.dart';

import '../test_utils.dart';

bool _containsExclusiveIt(suite) {
  final v = new guinness.ExclusiveVisitor();
  v.visitSuite(suite);
  return v.containsExclusiveIt;
}

bool _containsExclusiveDescribe(suite) {
  final v = new guinness.ExclusiveVisitor();
  v.visitSuite(suite);
  return v.containsExclusiveDescribe;
}

void main() {
  group("[containsExlclusiveIt]", () {
    test("return true when a suite has an iit", () {
      final suite = createSuite()
        ..add(createDescribe()..add(createIt(exclusive: true)));

      expect(_containsExclusiveIt(suite), isTrue);
    });

    test("ignores iit inside xdescribe", () {
      final suite = createSuite()
        ..add(createDescribe(excluded: true)..add(createIt(exclusive: true)));

      expect(_containsExclusiveIt(suite), isFalse);
    });

    test("returns false otherwise", () {
      final suite = createSuite()
        ..add(createDescribe()..add(createIt(exclusive: false)));

      expect(_containsExclusiveIt(suite), isFalse);
    });
  });

  group("[containsExlclusiveDescribe]", () {
    test("return true when a suite has an ddescribe", () {
      final suite = createSuite()..add(createDescribe(exclusive: true));

      expect(_containsExclusiveDescribe(suite), isTrue);
    });

    test("ignores ddescribe inside xdescribe", () {
      final suite = createSuite()
        ..add(createDescribe(excluded: true)
          ..add(createDescribe(exclusive: true)));

      expect(_containsExclusiveDescribe(suite), isFalse);
    });

    test("returns false otherwise", () {
      final suite = createSuite()..add(createDescribe());

      expect(_containsExclusiveDescribe(suite), isFalse);
    });
  });
}
