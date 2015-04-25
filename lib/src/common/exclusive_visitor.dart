part of guinness;

class ExclusiveVisitor implements SpecVisitor {
  bool containsExclusiveIt = false;
  bool containsExclusiveDescribe = false;

  void visitSuite(Suite suite) {
    _visitChildren(suite.children);
  }

  void visitDescribe(Describe describe) {
    if (describe.excluded) return;
    if (describe.exclusive) containsExclusiveDescribe = true;

    _visitChildren(describe.children);
  }

  void visitIt(It it) {
    if (it.excluded) return;
    if (it.exclusive) containsExclusiveIt = true;
  }

  _visitChildren(children) {
    children.forEach((c) => c.visit(this));
  }
}
