import 'dart:async';

import 'package:degust_et_des_couleurs/view/_my_colors.dart';
import 'package:degust_et_des_couleurs/view/_text_dm_sans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AutocompleteFieldCustom extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final FutureOr<Iterable<dynamic>> Function(String) suggestionsCallback;
  final Widget Function(BuildContext, dynamic) itemBuilder;
  final void Function(dynamic) onSuggestionSelected;
  final IconData prefixIcon;
  final Color prefixIconColor;
  final String? Function(String? value)? onValidate;

  const AutocompleteFieldCustom({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.suggestionsCallback,
    required this.itemBuilder,
    required this.onSuggestionSelected,
    required this.prefixIcon,
    required this.prefixIconColor,
    this.onValidate,
  });

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField(
      minCharsForSuggestions: 3,
      validator: onValidate ?? (value) { return null; },
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
        decoration: InputDecoration(
            filled: true,
            fillColor: MyColors().whiteColor,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: MyColors().secondaryColor,
                )),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: MyColors().secondaryColor,
              ),
            ),
            focusColor: MyColors().secondaryColor,
            prefixIcon: Icon(prefixIcon),
            prefixIconColor: prefixIconColor,
            labelText: placeholder,
            labelStyle: TextStyle(
              color: MyColors().greyColor,
            )),
      ),
      suggestionsCallback: suggestionsCallback,
      itemBuilder: itemBuilder,
      onSuggestionSelected: onSuggestionSelected,
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        color: MyColors().whiteColor,
        elevation: 0,
        shape: ContinuousRectangleBorder(
          side: BorderSide(
            color: MyColors().secondaryColor,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
      ),
      noItemsFoundBuilder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: const TextDmSans("Aucun résultat trouvés", fontSize: 15),
      ),
    );
  }
}
