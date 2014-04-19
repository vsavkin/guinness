part of jasmine;

class UnitTestVisitor implements SpecVisitor {
  void visitSuite(Suite suite){
    _visitChildren(suite.children);
  }

  void visitDescribe(Describe describe){
    if(describe.excluded) return;

    if(describe.exclusive) {
      unit.solo_group(describe.name, () {
        _visitChildren(describe.children);
      });
    } else {
      unit.group(describe.name, () {
        _visitChildren(describe.children);
      });
    }
  }

  void visitIt(It it){
    if(it.excluded) return;

    if(it.exclusive){
      unit.solo_test(it.name, it.withSetupAndTeardown);
    } else {
      unit.test(it.name, it.withSetupAndTeardown);
    }
  }

  _visitChildren(children){
    children.forEach((c) => c.visit(this));
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