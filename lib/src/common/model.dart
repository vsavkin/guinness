part of guinness;

class BeforeEach {
  final Function fn;
  final int priority;

  BeforeEach(this.fn, {this.priority});

  call() => fn();
}

class AfterEach {
  final Function fn;
  final int priority;

  AfterEach(this.fn, {this.priority});

  call() => fn();
}

abstract class Spec {
  final String name;
  final Describe parent;
  final bool excluded;
  final bool exclusive;

  Spec(this.name, this.parent, {this.excluded, this.exclusive});
}

class It extends Spec {
  final Function fn;

  It(String name, Describe parent, this.fn, {bool excluded, bool exclusive})
      : super(name, parent, excluded: excluded, exclusive: exclusive);

  Function get withSetupAndTeardown {
    return () => _runAllBeforeEach().then(_runItWithAfterEach);
  }

  Iterable<BeforeEach> get beforeEachFns {
    final fns = [];
    var c = parent;
    while(c != null){
      fns.insertAll(0, c.beforeEachFns);
      c = c.parent;
    }
    fns.sort((a, b) => Comparable.compare(b.priority, a.priority));
    return fns;
  }

  Iterable<AfterEach> get afterEachFns {
    final fns = [];
    var c = parent;
    while(c != null){
      fns.addAll(c.afterEachFns);
      c = c.parent;
    }
    fns.sort((a, b) => Comparable.compare(b.priority, a.priority));
    return fns;
  }

  void visit(SpecVisitor visitor) => visitor.visitIt(this);

  _runItWithAfterEach(_) {
    final success = (_) => _runAllAfterEach();
    final failure = (errorThrownByIt) => _runAllAfterEach().whenComplete(() => throw errorThrownByIt);
    return _runIt().then(success, onError: failure);
  }

  _runIt() => new async.Future.sync(() => fn());
  _runAllBeforeEach() =>_runAll(beforeEachFns);
  _runAllAfterEach() =>_runAll(afterEachFns);
  _runAll(List fns) => async.Future.forEach(fns, (fn) => fn());
}

class Describe extends Spec {
  final Context context;
  final List<BeforeEach> beforeEachFns = [];
  final List<AfterEach> afterEachFns = [];
  final List<Spec> children = [];

  Describe(String name, Describe parent, this.context, Function definition, {bool excluded, bool exclusive})
      : super(name, parent, excluded: excluded, exclusive: exclusive) {
    context.withDescribe(this, definition);
  }

  void addBeforeEach(BeforeEach beforeEach) {
    beforeEachFns.add(beforeEach);
  }

  void addAfterEach(AfterEach afterEach) {
    afterEachFns.add(afterEach);
  }

  void add(child) {
    children.add(child);
  }

  String get name => exclusive ? 'DDESCRIBE: ${super.name}' : super.name;

  void visit(SpecVisitor visitor) => visitor.visitDescribe(this);
}

class Suite extends Describe {
  Suite(Context context)
      : super(null, null, context, (){});

  void visit(SpecVisitor visitor) => visitor.visitSuite(this);
}