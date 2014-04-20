part of jasmine_test;

class DummyVisitor implements jasmine.SpecVisitor {
  void visitSuite(jasmine.Suite suite){
    suite.children.forEach((c) => c.visit(this));
  }

  void visitDescribe(jasmine.Describe describe){
    describe.children.forEach((c) => c.visit(this));
  }

  void visitIt(jasmine.It it){
    it.withSetupAndTeardown();
  }
}

void runTests(jasmine.Context context){
  context.suite.visit(new DummyVisitor());
}

testIntegration(){
  group("[integration]", (){
    var context;

    setUp((){
      context = jasmine.context = new jasmine.Context(runner: (_){});
    });

    test("runs specs once", (){
      var log = [];
      jasmine.describe("outer describe", (){
        jasmine.it("outer it", (){
          log.add("outer it");
        });

        jasmine.describe("inner describe", (){
          jasmine.it("inner it", (){
            log.add("inner it");
          });
        });
      });

      runTests(context);

      expect(log, equals(["outer it", "inner it"]));
    });

    test("runs beforeEach and afterEach blocks", (){
      var log = [];

      jasmine.describe("outer describe", (){
        jasmine.beforeEach((){
          log.add("outer beforeEach");
        });

        jasmine.afterEach((){
          log.add("outer afterEach");
        });

        jasmine.describe("inner describe", (){
          jasmine.beforeEach((){
            log.add("inner beforeEach");
          });

          jasmine.afterEach((){
            log.add("inner afterEach");
          });

          jasmine.it("inner it", (){
            log.add("inner it");
          });
        });
      });

      runTests(context);

      expect(log, equals(["outer beforeEach", "inner beforeEach", "inner it", "inner afterEach", "outer afterEach"]));
    });
  });
}