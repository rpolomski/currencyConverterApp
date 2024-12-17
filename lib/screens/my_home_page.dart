import 'package:f_currency_converter/currency_dropdown_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/data_cubit.dart';
import '../cubit/data_state.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _dropdownValue = "USD";
  String? code = "USD";
  double? rate;
  final TextEditingController _plnController = TextEditingController();
  final TextEditingController _otherCurrencyController =
      TextEditingController();
  String? convertedAmount = '';
  String? plnAmount = '';
  bool dataFetched = false;

  void dropdownCallback(String? selectedValue) {
    if (selectedValue != null) {
      setState(() {
        _dropdownValue = selectedValue;
        convertedAmount = '';
        plnAmount = '';
      });
    }
  }

  void convertToCode() {
    double? pln = double.tryParse(_plnController.text);

    if (pln != null && rate != null) {
      setState(() {
        convertedAmount = (pln / rate!).toStringAsFixed(2);
        code = _dropdownValue;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid input or rate not available")),
      );
    }
  }

  void convertToPln() {
    double? otherCurrencyAmount =
        double.tryParse(_otherCurrencyController.text);

    if (otherCurrencyAmount != null && rate != null) {
      setState(() {
        plnAmount = (otherCurrencyAmount * rate!).toStringAsFixed(2);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid input or rate not available")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: <Color>[
            Color(0xFFFFD700),
            Color(0xFF2F2F2F),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: ListView(children: [Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DropdownButton<String>(
                  dropdownColor: Colors.yellow.shade300,
                  isExpanded: true,
                  hint: const Text("Select currency"),
                  items: currencyDropdownItem(),
                  value: _dropdownValue,
                  onChanged: dropdownCallback,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_dropdownValue != null) {
                      setState(() {
                        code = _dropdownValue;
                        dataFetched = true;
                        plnAmount = "";
                        convertedAmount = "";
                      });
                      context.read<DataCubit>().fetchData(_dropdownValue!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please select a currency")),
                      );
                    }
                  },
                  child: const Text("Fetch Data"),
                ),
                const SizedBox(height: 30),
                BlocBuilder<DataCubit, DataState>(
                  builder: (context, state) {
                    if (state is DataLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is DataLoaded) {
                      final data = state.data;
                      final currency = data["currency"] ?? "Unknown";
                      code = data["code"] ?? "Unknown";
                      try {
                        rate = double.tryParse(data["rate"].toString());
                      } catch (e) {
                        rate = 0.0;
                      }



                      return Column(
                        children: [
                          Text("Currency: $currency"),
                          Text("Code: $code"),
                          Text("Rate: $rate"),
                        ],
                      );
                    } else if (state is DataError) {
                      return const Text("Error occurred while fetching data");
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _plnController,
                        keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*')),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'PLN',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.currency_exchange),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        (convertedAmount != null && convertedAmount != '')
                            ? convertedAmount!
                            : (code != null && code != "Unknown")
                            ? code!
                            : 'Currency',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: convertToCode,
                  child: Text(dataFetched
                      ? "Convert to ${code ?? 'Currency'}"
                      : "Convert to currency"),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _otherCurrencyController,
                        keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*')),
                        ],
                        decoration: InputDecoration(
                          labelText: code,
                          hintText: 'Enter amount here...',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.currency_exchange),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        plnAmount != null && plnAmount != '' ? plnAmount! : 'PLN',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: convertToPln,
                  child: const Text("Convert to PLN"),
                ),
              ],
            ),
          ),],

          ),
        ),
      ),
    );
  }
}
