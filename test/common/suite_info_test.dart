library guinness.test.suit_info_test;

import 'package:guinness/guinness.dart' as guinness;
import 'package:unittest/unittest.dart';

import '../test_utils.dart';

void main() {
  setUp(() {
    final context = new guinness.Context();
    guinness.guinness.resetContext(context);
  });

  test("describes", () {
    guinness.describe("outer", () {
      guinness.xdescribe("xdescribe", noop);
      guinness.ddescribe("ddescribe", noop);
      guinness.describe("inner describe", noop);
    });
    guinness.describe("pending describe");

    final suiteInfo = guinness.guinness.suiteInfo();
    expect(suiteInfo.numberOfDescribes, equals(5));
    expect(suiteInfo.exclusiveDescribes.length, equals(1));
    expect(suiteInfo.excludedDescribes.length, equals(1));
    expect(suiteInfo.pendingDescribes.length, equals(1));
  });

  test("its", () {
    guinness.it("one", noop);
    guinness.xit("two", noop);
    guinness.iit("three", noop);
    guinness.it("pending it");

    final suiteInfo = guinness.guinness.suiteInfo();
    expect(suiteInfo.numberOfIts, equals(4));
    expect(suiteInfo.exclusiveIts.length, equals(1));
    expect(suiteInfo.excludedIts.length, equals(1));
    expect(suiteInfo.pendingIts.length, equals(1));
  });

  group("[activeIts]", () {
    test("ignores its in xdescribe", () {
      guinness.it("one", noop);

      guinness.xdescribe("xdescribe", () {
        guinness.it("two", noop);
      });

      final suiteInfo = guinness.guinness.suiteInfo();
      expect(suiteInfo.activeIts.length, equals(1));
    });

    test("ignores pending its", () {
      guinness.it("one");

      final suiteInfo = guinness.guinness.suiteInfo();
      expect(suiteInfo.activeIts.length, equals(0));
    });

    test("counts only its in ddescribes", () {
      guinness.it("one", noop);

      guinness.ddescribe("ddescribe", () {
        guinness.it("two", noop);
      });

      final suiteInfo = guinness.guinness.suiteInfo();
      expect(suiteInfo.activeIts.length, equals(1));
    });

    test("counts only iits", () {
      guinness.it("one", noop);

      guinness.describe("describe", () {
        guinness.iit("two", noop);
      });

      final suiteInfo = guinness.guinness.suiteInfo();
      expect(suiteInfo.activeIts.length, equals(1));
    });

    test("ignores iits in xdescribe", () {
      guinness.it("one", noop);

      guinness.xdescribe("xdescribe", () {
        guinness.iit("two", noop);
        guinness.iit("three", noop);
      });

      final suiteInfo = guinness.guinness.suiteInfo();
      expect(suiteInfo.activeIts.length, equals(1));
    });

    group('[activeItsPercent]', () {
      test("is the percent of active tests in the suite", () {
        guinness.it("one", noop);
        guinness.iit("one", noop);

        final suiteInfo = guinness.guinness.suiteInfo();
        expect(suiteInfo.activeItsPercent, equals(50));
      });

      test("is zero when not specs", () {
        final suiteInfo = guinness.guinness.suiteInfo();
        expect(suiteInfo.activeItsPercent, equals(0));
      });
    });
  });
}
