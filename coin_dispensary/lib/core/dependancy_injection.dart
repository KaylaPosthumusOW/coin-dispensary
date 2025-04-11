import 'package:casha/constants/constants.dart';
import 'package:casha/cubits/simple_calc/simple_calc_cubit.dart';

class DependencyInjection {
  static Future<void> init() async {
    await _packages();
    await _repos();
    await _cubits();
    await _main();
  }

  static Future<void> _main() async {
    // All main packages and services should be registered here
  }

  static _repos() {
    // All repositories should be registered here
  }

  static _cubits() async {
    // All cubits should be registered here
    sl.registerLazySingleton<SimpleCalcCubit>(() => SimpleCalcCubit());
  }

  static _packages() async {
    // All packages should be registered here
  }
}
