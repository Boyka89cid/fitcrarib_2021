import 'package:flutter/material.dart';
import 'package:fitcarib/utils/country_code_picker/celement.dart';
import 'package:fitcarib/utils/country_code_picker/country_codes.dart';
import 'package:fitcarib/utils/country_code_picker/selection_dialog.dart';

export 'celement.dart';

class CountryCodePicker extends StatefulWidget
{
  final Function(CElement)? onChanged;
  final String? initialSelection;
  final List<String>? favorite;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;

  CountryCodePicker(
      {this.onChanged,
      this.initialSelection,
      this.favorite,
      this.textStyle,
      this.padding});

  @override
  State<StatefulWidget> createState() {
    List<Map> jsonList = codes;

    List<CElement> elements = jsonList
        .map((s) => new CElement(
              name: s['name'],
              code: s['code'],
              dialCode: s['dial_code'],
              flagUri: 'assets/flags/${s['code'].toLowerCase()}.png',
            ))
        .toList();

    return new _CountryCodePickerState(elements);
  }
}

class _CountryCodePickerState extends State<CountryCodePicker>
{
  CElement? selectedItem;
  List<CElement> elements = [];
  List<CElement> favoriteElements = [];

  _CountryCodePickerState(this.elements);

  @override
  Widget build(BuildContext context) {
    if (widget.initialSelection != null) {
      selectedItem = elements.firstWhere(
          (e) =>
              (e.code!.toUpperCase() == widget.initialSelection!.toUpperCase()) ||
              (e.dialCode == widget.initialSelection.toString()),
          orElse: () => elements[0]);
    } else {
      selectedItem = elements[0];
    }

    favoriteElements = elements
        .where((e) =>
            widget.favorite!.firstWhere((f) => e.code == f.toUpperCase() || e.dialCode == f.toString(), orElse: () => '') != null)
        .toList();

    return new FlatButton(
      child: Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset(
                selectedItem!.flagUri as String,
                //package: 'country_code_picker',
                width: 32.0,
              ),
            ),
          ),
          Flexible(
            child: Text(
              selectedItem.toString(),
              style: widget.textStyle ?? Theme.of(context).textTheme.button,
            ),
          ),
        ],
      ),
      padding: widget.padding,
      onPressed: _showSelectionDialog,
    );
  }

  void _showSelectionDialog() {
    showDialog(
      context: context,
      builder: (_) => new SelectionDialog(elements, favoriteElements),
    ).then((e) {
      if (e != null) {
        setState(() {
          selectedItem = e;
        });

        _publishSelection(e);
      }
    });
  }

  void _publishSelection(CElement e) {
    if (widget.onChanged != null) {
      widget.onChanged!(e);
    }
  }
}
