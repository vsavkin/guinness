part of guinness;

_printStats(Suite suite){
  final visitor = new _StatsSpecVisitor();
  visitor.visitSuite(suite);
  visitor.printStats();
}

class _StatsSpecVisitor implements SpecVisitor {
  final exclusiveDescribes = [];
  final excludedDescribes = [];

  final exclusiveIts = [];
  final excludedIts = [];

  int numberOfIts = 0;
  int numberOfDescribes = 0;

  void visitSuite(Suite suite) {
    _visitChildren(suite.children);
  }

  void visitDescribe(Describe describe) {
    if (describe.excluded) excludedDescribes.add(describe);

    if (describe.exclusive) exclusiveDescribes.add(describe);

    numberOfDescribes += 1;

    _visitChildren(describe.children);
  }

  void visitIt(It it) {
    if (it.excluded) excludedIts.add(it);

    if (it.exclusive) exclusiveIts.add(it);

    numberOfIts += 1;
  }

  void printStats() {
    print("---- -------------- ----");
    print("---- Guinness Stats ----");
    print("---- -------------- ----");

    print("Total: Describe (${numberOfDescribes}), It (${numberOfIts})");
    print("Excluded: Describe (${excludedDescribes.length}), It (${excludedIts.length})");
    print("Exclusive: Describe (${exclusiveDescribes.length}), It (${exclusiveIts.length})");

    if(exclusiveIts.isNotEmpty && exclusiveDescribes.isNotEmpty) {
      print("WARNING: Exclusive It blocks have higher priority than exlusive Describe blocks");
    }

    print("---- Details ----");
    print("Exclusive Describe: ${exclusiveDescribes.map((_) => _.name)}");
    print("Exclusive It: ${exclusiveIts.map((_) => _.name)}");

    print("---- -------------- ----");
    print("---- Guinness Stats ----");
    print("---- -------------- ----");
  }

  void _visitChildren(children) {
    children.forEach((c) => c.visit(this));
  }
}
