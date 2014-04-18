library jasmine_syntax_test;

import 'package:jasmine_dart/jasmine.dart';


main(){
  it("aaa", (){
    expect(5).toEqual(3);
  });

  describe("bbb", (){
    it("ddd", (){
      expect(5).toEqual(3);
    });
  });

  it("ccc", (){
    expect(5).toEqual(4);
  });
}