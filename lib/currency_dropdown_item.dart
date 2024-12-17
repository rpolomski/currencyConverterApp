import 'package:flutter/material.dart';

List<DropdownMenuItem<String>> currencyDropdownItem() {
  return const [
    DropdownMenuItem(
      value: "USD",
      child: Text("Dolar amerykański"),
    ),
    DropdownMenuItem(
      value: "EUR",
      child: Text("Euro"),
    ),
    DropdownMenuItem(
      value: "GBP",
      child: Text("Funt angielski"),
    ),
    DropdownMenuItem(
      value: "THB",
      child: Text("Bat"),
    ),
    DropdownMenuItem(
      value: "CAD",
      child: Text("Dolar kanadyjski"),
    ),
    DropdownMenuItem(
      value: "HUF",
      child: Text("Forint"),
    ),
    DropdownMenuItem(
      value: "UAH",
      child: Text("Hrywna"),
    ),
    DropdownMenuItem(
      value: "MXN",
      child: Text("Peso meksykańskie"),
    ),
  ];
}
