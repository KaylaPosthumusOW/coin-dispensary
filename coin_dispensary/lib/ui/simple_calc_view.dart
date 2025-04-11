import 'package:casha/constants/constants.dart';
import 'package:casha/cubits/simple_calc/simple_calc_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleCalcView extends StatelessWidget {
  final SimpleCalcCubit _simpleCalcCubit = sl.get<SimpleCalcCubit>();

  final TextEditingController _costController = TextEditingController(text: '25.50');
  final TextEditingController _tenderController = TextEditingController(text: '50');

  void _calculateChange(BuildContext context) {
    _simpleCalcCubit.calculateWithMod(
      double.tryParse(_costController.text),
      double.tryParse(_tenderController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Calculator'),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: () => _simpleCalcCubit.clearAll()),
        ],
      ),
      body: BlocBuilder<SimpleCalcCubit, SimpleCalcState>(
  bloc: _simpleCalcCubit,
  builder: (context, state) {
    if (state is SimpleCalcError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            state.message,
            style: TextStyle(color: Colors.red, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } // <-- Add this closing brace
    if (state is SimpleCalcCalculated) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text('Product Cost:')),
                          Expanded(child: TextField(controller: _costController)),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text('Tender Amount:')),
                          Expanded(child: TextField(controller: _tenderController)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Offstage(
                offstage: state.breakdown.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(child: Text('See simple_calc_cubit.dart TODO')),
                ),
              ),
              Offstage(
                offstage: state.breakdown.isEmpty,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total change R${state.totalChange}', style: TextStyle(fontWeight: FontWeight.bold)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_hasNotes(state.breakdown)) ...[
                              Text('🧾 Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
                              ..._buildEntries(state.breakdown, isNote: true),
                            ],
                            SizedBox(height: 10),
                            if (_hasCoins(state.breakdown)) ...[
                              Text('🪙 Coins:', style: TextStyle(fontWeight: FontWeight.bold)),
                              ..._buildEntries(state.breakdown, isNote: false),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(child: Container()),
              ElevatedButton(
                onPressed: () => _calculateChange(context),
                child: Text('Calculate change'),
              )
            ],
          ),
        ),
      );
    }

    return Container();
  },
),
    );
  }
}

bool _hasNotes(Map<String, num> breakdown) {
  return breakdown.keys.any((key) => double.tryParse(key)! >= 10);
}

bool _hasCoins(Map<String, num> breakdown) {
  return breakdown.keys.any((key) => double.tryParse(key)! < 10);
}

List<Widget> _buildEntries(Map<String, num> breakdown, {required bool isNote}) {
  return breakdown.entries
      .where((entry) {
        final value = double.tryParse(entry.key) ?? 0;
        return isNote ? value >= 10 : value < 10;
      })
      .map((entry) => Text('R${entry.key} x ${entry.value}'))
      .toList();
}
