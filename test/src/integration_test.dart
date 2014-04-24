part of guinness_test;

class DummyVisitor implements guinness.SpecVisitor {
  void visitSuite(guinness.Suite suite){
    suite.children.forEach((c) => c.visit(this));
  }

  void visitDescribe(guinness.Describe describe){
    describe.children.forEach((c) => c.visit(this));
  }

  void visitIt(guinness.It it){
    it.withSetupAndTeardown();
  }
}

void runTests(guinness.Context context){
  context.suite.visit(new DummyVisitor());
}

testIntegration(){
  group("[integration]", (){
    var context;

    setUp((){
      context = new guinness.Context();
      guinness.guinness.resetContext(context);
    });

    test("runs specs once", (){
      var log = [];
      guinness.describe("outer describe", (){
        guinness.it("outer it", (){
          log.add("outer it");
        });

        guinness.describe("inner describe", (){
          guinness.it("inner it", (){
            log.add("inner it");
          });
        });
      });

      runTests(context);

      expect(log, equals(["outer it", "inner it"]));
    });

    test("runs beforeEach and afterEach blocks", (){
      var log = [];

      guinness.describe("outer describe", (){
        guinness.beforeEach((){
          log.add("outer beforeEach");
        });

        guinness.afterEach((){
          log.add("outer afterEach");
        });

        guinness.describe("inner describe", (){
          guinness.beforeEach((){
            log.add("inner beforeEach");
          });

          guinness.afterEach((){
            log.add("inner afterEach");
          });

          guinness.it("inner it", (){
            log.add("inner it");
          });
        });
      });

      runTests(context);

      expect(log, equals(["outer beforeEach", "inner beforeEach", "inner it", "inner afterEach", "outer afterEach"]));
    });
  });
}