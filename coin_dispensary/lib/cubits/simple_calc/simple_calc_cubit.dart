import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'simple_calc_state.dart';

class SimpleCalcCubit extends Cubit<SimpleCalcState> {
  SimpleCalcCubit() : super(SimpleCalcCalculated({}, 0));

  void calculateWithMod(double? cost, double? tender) {
    if (cost == null || tender == null) return;

    num totalChange = tender - cost;

    if (tender < cost) {
      emit(SimpleCalcError('Tendered amount is less than the cost. ')); // Emit error state
      return;
    }
    // Round total change to 2 decimals
    totalChange = num.parse(totalChange.toStringAsFixed(2));

    Map<String, num> breakdown = {}; // The map to hold the breakdown of the change. A string value of the denomination and a number of how many of that denomination to give. Example: {200: 1, 50: 2}

    List<num> denominations = [200, 100, 50, 20, 10, 5, 2, 1, 0.50, 0.20, 0.10];

    num remaining = totalChange;

    for (num denomination in denominations) {
      int count = (remaining / denomination).floor();

      if (count > 0) {
        breakdown[denomination.toString()] = count;
        remaining -= count * denomination;

        // Round remaining after each step
        remaining = num.parse(remaining.toStringAsFixed(2));
      }
    }
    
    // Emit the fixed breakdown and the full total change
    emit(SimpleCalcCalculated(breakdown, totalChange));
  }

  void clearAll() {
    emit(SimpleCalcCalculated({}, 0));
  }
}

