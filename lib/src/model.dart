part of jasmine;

abstract class SpecVisitor {
  void visitSuite(Suite describe);
  void visitDescribe(Describe describe);
  void visitSpec(Spec sped);
}

abstract class Matchers {
  void expectToEqual(actual, expected);
}

class Context {
  final List<Describe> describes = [];
  final Matchers matchers;

  Describe get currentDescribe => describes.last;
  Describe get suite => describes.first;

  Context({Function runner, this.matchers}){
    describes.add(new Suite(this));
    runner(suite);
  }

  void withDescribe(Describe describe, Function definition){
    describes.add(describe);
    try{
      definition();
    } finally {
      describes.removeLast();
    }
  }
}

class Spec {
  final String name;
  final Function callback;

  Spec(this.name, this.callback);

  void visit(SpecVisitor visitor) => visitor.visitSpec(this);
}

class Describe {
  final String name;
  final Context context;
  final List children = [];

  Describe(this.name, this.context, Function definition){
    context.withDescribe(this, definition);
  }

  void addSpec(String name, Function callback){
    children.add(new Spec(name, callback));
  }

  void addDescribe(String name, Function callback){
    children.add(new Describe(name, context, callback));
  }

  void visit(SpecVisitor visitor) => visitor.visitDescribe(this);
}

class Suite extends Describe {
  Suite(Context context): super(null, context, (){});

  void visit(SpecVisitor visitor) => visitor.visitSuite(this);
}