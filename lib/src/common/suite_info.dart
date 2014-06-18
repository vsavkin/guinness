part of guinness;

_suiteInfo(Suite suite){
  final visitor = new _SuiteInfoVisitor();
  visitor.visitSuite(suite);
  return visitor.info;
}

class SuiteInfo {
  final List<Describe> exclusiveDescribes = [];
  final List<Describe> excludedDescribes = [];

  final List<It> exclusiveIts = [];
  final List<It> excludedIts = [];
  final List<It> activeIts = [];

  int numberOfIts = 0;
  int numberOfDescribes = 0;

  int get numberOfActiveIts => activeIts.length;
  bool get hasActiveIts => activeIts.isNotEmpty;
  int get activeItsPercent => numberOfIts > 0 ? (activeIts.length / numberOfIts * 100).toInt() : 0;

  @deprecated
  void printDetailedStats() {
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
}

class _SuiteInfoVisitor implements SpecVisitor {
  final SuiteInfo info = new SuiteInfo();

  bool containsExclusiveIt;
  bool containsExclusiveDescribe;

  void visitSuite(Suite suite) {
    final v = new ExclusiveVisitor();
    v.visitSuite(suite);
    containsExclusiveIt = v.containsExclusiveIt;
    containsExclusiveDescribe = v.containsExclusiveDescribe;

    _visitChildren(suite.children);
  }

  void visitDescribe(Describe describe) {
    if (describe.excluded) info.excludedDescribes.add(describe);
    if (describe.exclusive) info.exclusiveDescribes.add(describe);

    info.numberOfDescribes += 1;

    _visitChildren(describe.children);
  }

  void visitIt(It it) {
    if (it.excluded) info.excludedIts.add(it);
    if (it.exclusive) info.exclusiveIts.add(it);

    info.numberOfIts += 1;

    if (_isActive(it)) info.activeIts.add(it);
  }

  bool _isActive(it) {
    if (containsExclusiveIt) {
      return it.exclusive;
    } else if (containsExclusiveDescribe) {
      return _exclusiveParent(it.parent);
    } else {
      return _activeParent(it.parent);
    }
  }

  void _visitChildren(children) {
    children.forEach((c) => c.visit(this));
  }

  bool _exclusiveParent(spec) {
    if (spec == null) return false;
    if (spec.excluded == true) return false;
    if (spec.exclusive == true) return true;
    return _exclusiveParent(spec.parent);
  }

  bool _activeParent(spec) {
    if (spec == null) return true;
    if (spec.excluded == true) return false;
    if (spec.exclusive == true) return true;
    return _activeParent(spec.parent);
  }
}
