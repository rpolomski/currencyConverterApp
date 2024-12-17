import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data_state.dart';

class DataCubit extends Cubit<DataState> {
  DataCubit() : super(DataInitial());

  void fetchData(String currencyCode) async {
    emit(DataLoading());
    try {
      final response = await Dio().get(
          "https://api.nbp.pl/api/exchangerates/rates/a/$currencyCode/?format=json");
      final filteredData = {
        "currency": response.data["currency"],
        "code": response.data["code"],
        "rate": response.data["rates"][0]["mid"],
      };
      emit(DataLoaded(filteredData));
    } catch (e) {
      emit(DataError());
    }
  }
}
