import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:nop/nop.dart';
import 'package:nop_flutter/nop_state.dart';

void main() {
  test('nop dependences test', () {
    runZoned(() {
      final first = create('first');
      final second = create('second');
      final third = create('third');
      first.updateChild(second);
      second.updateChild(third);
      forEach(first);
      final four = create('four');
      first.updateChild(four);
      forEach(first);

      expect(second.parent == null && second.child == null, true);
    },
        zoneSpecification: ZoneSpecification(
          print: (self, parent, zone, line) => Zone.root.print(line),
        ));
  });
  test('nop dependences insert', () {
    Zone.root.run(() {
      final first = create('first');
      final second = create('second');
      final third = create('third');
      first.insertChild(second);
      second.insertChild(third);
      forEach(first);
      final four = create('four');
      first.insertChild(four);
      forEach(first);

      second.removeCurrent();
      forEach(first);
    });
  });
}

void forEach(NopDependencies root) {
  NopDependencies? child = root;
  Log.i('_'.padLeft(50, '_'));
  while (child != null) {
    Log.i('$child parent: ${child.parent}');
    child = child.child;
  }
}

NopDependencies create(String name) {
  return NopDependencies(debugName: name);
}
