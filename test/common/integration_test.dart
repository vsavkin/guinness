library guinness.test.integration_test;

import 'dart:async';

import 'package:guinness/guinness.dart' as guinness;
import 'package:unittest/unittest.dart';

class DummyVisitor implements guinness.SpecVisitor {
  List<Future> allFutures = [];

  void visitSuite(guinness.Suite suite) {
    suite.children.forEach((c) => c.visit(this));
  }

  void visitDescribe(guinness.Describe describe) {
    describe.children.forEach((c) => c.visit(this));
  }

  void visitIt(guinness.It it) {
    allFutures.add(it.withSetupAndTeardown());
  }

  waitForAll() => Future.wait(allFutures);
}

main() {
  var context;

  void verify(Function fn) {
    final visitor = new DummyVisitor();
    context.suite.visit(visitor);
    visitor
        .waitForAll()
        .then(expectAsync((_) => fn()))
        .catchError((e) => print(e));
  }

  setUp(() {
    context = new guinness.Context();
    guinness.guinness.resetContext(context);
  });

  test("runs specs once", () {
    var log = [];

    guinness.describe("outer describe", () {
      guinness.it("outer it", () {
        log.add("outer it");
      });

      guinness.describe("inner describe", () {
        guinness.it("inner it", () {
          log.add("inner it");
        });
      });
    });

    verify(() {
      expect(log, equals(["outer it", "inner it"]));
    });
  });

  test("runs beforeEach and afterEach blocks", () {
    var log = [];

    guinness.describe("outer describe", () {
      guinness.beforeEach(() {
        log.add("outer beforeEach");
      });

      guinness.afterEach(() {
        log.add("outer afterEach");
      });

      guinness.describe("inner describe", () {
        guinness.beforeEach(() {
          log.add("inner beforeEach");
        });

        guinness.afterEach(() {
          log.add("inner afterEach");
        });

        guinness.it("inner it", () {
          log.add("inner it");
        });
      });
    });

    verify(() {
      expect(log, equals([
        "outer beforeEach",
        "inner beforeEach",
        "inner it",
        "inner afterEach",
        "outer afterEach"
      ]));
    });
  });

  group("when beforeEach, afterEach, and it return futures", () {
    test("waits for them to be completed", () {
      var log = [];

      futurePrinting(message) => new Future.microtask(() {
        log.add(message);
      });

      guinness.describe("outer describe", () {
        guinness.beforeEach(() => futurePrinting("outer beforeEach"));
        guinness.afterEach(() => futurePrinting("outer afterEach"));

        guinness.describe("inner describe", () {
          guinness.beforeEach(() => futurePrinting("inner beforeEach"));
          guinness.afterEach(() => futurePrinting("inner afterEach"));

          guinness.it("inner it", () => futurePrinting("inner it"));
        });
      });

      verify(() {
        expect(log, equals([
          "outer beforeEach",
          "inner beforeEach",
          "inner it",
          "inner afterEach",
          "outer afterEach"
        ]));
      });
    });
  });

  test("pending describes and its", () {
    guinness.describe("pending describe");
    guinness.xdescribe("pending excluded describe");
    guinness.ddescribe("pending exclusive describe");

    guinness.it("pending it");
    guinness.xit("pending exlcluded it");
    guinness.iit("pending exclusive it");
    verify(() {});
  });
}
