part of guinness;

class Context {
  final List<Describe> describes = [];

  Describe get currentDescribe => describes.last;
  Describe get suite => describes.first;

  Context() {
    describes.add(new Suite(this));
  }

  void withDescribe(Describe describe, Function definition) {
    describes.add(describe);
    try {
      definition();
    } finally {
      describes.removeLast();
    }
  }

  void addBeforeEach(Function fn, {int priority}) {
    final beforeEach = new BeforeEach(fn, priority: priority);
    currentDescribe.addBeforeEach(beforeEach);
  }

  void addAfterEach(Function fn, {int priority}) {
    final afterEach = new AfterEach(fn, priority: priority);
    currentDescribe.addAfterEach(afterEach);
  }

  void addIt(String name, Function fn, {bool excluded, bool exclusive}) {
    final it = new It(name, currentDescribe, fn,
        excluded: excluded, exclusive: exclusive);
    currentDescribe.add(it);
  }

  void addDescribe(String name, Function fn, {bool excluded, bool exclusive}) {
    final describe = new Describe(name, currentDescribe, this, fn,
        excluded: excluded, exclusive: exclusive);
    currentDescribe.add(describe);
  }
}
