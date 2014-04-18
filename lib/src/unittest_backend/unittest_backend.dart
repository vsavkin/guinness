part of jasmine;

class UnitTestVisitor implements SpecVisitor {
  void visitSuite(Suite suite){
    suite.children.forEach((c) => c.visit(this));
  }

  void visitDescribe(Describe describe){
    unit.group(describe.name, (){
      describe.children.forEach((c) => c.visit(this));
    });
  }

  void visitSpec(Spec spec){
    unit.test(spec.name, spec.callback);
  }
}

class UnitTestMatchers implements Matchers {
  expectToEqual(actual, expected) =>
      unit.expect(actual, unit.equals(expected));
}

void unitTestRunner(Suite suite){
  var r = new UnitTestVisitor();
  async.scheduleMicrotask((){
    suite.visit(r);
  });
}