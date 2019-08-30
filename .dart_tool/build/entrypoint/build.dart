// ignore_for_file: directives_ordering

import 'package:build_runner_core/build_runner_core.dart' as _i1;
import 'package:built_redux/builder.dart' as _i2;
import 'package:built_value_generator/builder.dart' as _i3;
import 'package:source_gen/builder.dart' as _i4;
import 'package:build_config/build_config.dart' as _i5;
import 'dart:isolate' as _i6;
import 'package:build_runner/build_runner.dart' as _i7;

final _builders = <_i1.BuilderApplication>[
  _i1.apply('built_redux:built_redux', [_i2.builtRedux],
      _i1.toDependentsOf('built_redux'),
      hideOutput: true, appliesBuilders: ['source_gen:combining_builder']),
  _i1.apply('built_value_generator:built_value', [_i3.builtValue],
      _i1.toDependentsOf('built_value_generator'),
      hideOutput: true, appliesBuilders: ['source_gen:combining_builder']),
  _i1.apply('source_gen:combining_builder', [_i4.combiningBuilder],
      _i1.toNoneByDefault(),
      hideOutput: false, appliesBuilders: ['source_gen:part_cleanup']),
  _i1.applyPostProcess('source_gen:part_cleanup', _i4.partCleanup,
      defaultGenerateFor: const _i5.InputSet())
];
main(List<String> args, [_i6.SendPort sendPort]) async {
  var result = await _i7.run(args, _builders);
  sendPort?.send(result);
}
