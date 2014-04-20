part of jasmine;

class Context {
  final List<Describe> describes = [];

  Describe get currentDescribe => describes.last;
  Describe get suite => describes.first;

  Context(){
    describes.add(new Suite(this));
  }

  void withDescribe(Describe describe, Function definition){
    describes.add(describe);
    try{
      definition();
    } finally {
      describes.removeLast();
    }
  }

  void addBeforeEach(Function fn, {int priority}){
    currentDescribe.addBeforeEach(new BeforeEach(fn, priority: priority));
  }

  void addAfterEach(Function fn, {int priority}){
    currentDescribe.addAfterEach(new AfterEach(fn, priority: priority));
  }

  void addIt(String name, Function fn, {bool excluded, bool exclusive}){
    currentDescribe.add(new It(name, currentDescribe, fn, excluded: excluded, exclusive: exclusive));
  }

  void addDescribe(String name, Function fn, {bool excluded, bool exclusive}){
    currentDescribe.add(new Describe(name, currentDescribe, this, fn, excluded: excluded, exclusive: exclusive));
  }
}