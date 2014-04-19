part of jasmine;

class Jasmine {
  createSpy([String name]) {
    return new SpyFunction(name);
  }

  SpyFunction spyOn(receiver, methodName) {
    throw ["spyOn not implemented"];
  }
}

class SpyFunctionInvocationResult {
  final List args;
  SpyFunctionInvocationResult(this.args);
}

@proxy
class SpyFunction {
  final String name;
  final List<List> invocations = [];
  var _callFakeFn;

  SpyFunction(this.name);

  andCallFake(fn) {
    _callFakeFn = fn;
    return this;
  }

  call([a0=_e, a1=_e, a2 =_e, a3=_e, a4=_e, a5=_e]) =>
      _processCall(_takeNonEmpty([a0, a1, a2, a3, a4, a5]));

  noSuchMethod(Invocation c){
    if(c.memberName == #call){
      return _processCall(c.positionalArguments);
    } else {
      return super.noSuchMethod(c);
    }
  }

  void reset() => invocations.clear();

  num get count => invocations.length;
  num get callCount => count;
  bool get called => count > 0;

  SpyFunctionInvocationResult get mostRecentCall {
    if (invocations.isEmpty) {
      throw ["No calls"];
    }
    return new SpyFunctionInvocationResult(invocations.last);
  }

  _processCall(List posArgs){
    invocations.add(posArgs);

    if(_callFakeFn != null){
      return Function.apply(_callFakeFn, posArgs);
    }
  }
}

class _Empty{
  const _Empty();
}
const _e = const _Empty();
List _takeNonEmpty(List iter) => iter.takeWhile((_) => _ != _e).toList();