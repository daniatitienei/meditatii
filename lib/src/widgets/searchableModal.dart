import 'package:diacritic/diacritic.dart';
import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Searchable extends StatefulWidget {
  final List<String> data;
  final String defaultValue;
  final Function callBack;

  const Searchable({
    required this.data,
    required this.defaultValue,
    required this.callBack,
    Key? key,
  }) : super(key: key);

  @override
  _SearchableState createState() => _SearchableState();
}
// TODO SA DEA VALOAREA INAPOI

class _SearchableState extends State<Searchable> {
  final TextEditingController _searchController = TextEditingController();

  List<String> data = [], _foundSearches = [];

  String? _selectedItem;

  void _runFilter(String text) {
    List<String> results = [];

    if (text.isEmpty)
      results = this.data;
    else
      results = this
          .data
          .where((item) =>
              item.toLowerCase().contains(removeDiacritics(text.toLowerCase())))
          .toList();

    setState(() {
      _foundSearches = results;
    });
  }

  _buildSearchableModal() => showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.search,
                      color: MyColors().purple,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) => _runFilter(value),
                      controller: _searchController,
                      cursorColor: MyColors().purple,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(color: MyColors().purple),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Scrieti aici',
                        hintStyle: GoogleFonts.roboto(
                          color: MyColors().purpleSixtyPercent,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 1,
                color: MyColors().purple,
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      widget.callBack(_foundSearches[index]);

                      setState(() {
                        _selectedItem = _foundSearches[index];
                      });

                      Navigator.of(context).pop();
                    },
                    leading: Text(_foundSearches[index]),
                  ),
                  itemCount: _foundSearches.length,
                ),
              ),
            ],
          ),
        ),
      );

  @override
  void initState() {
    data = widget.data;
    _foundSearches = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _buildSearchableModal(),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _selectedItem == null
                  ? MyColors().purpleSixtyPercent
                  : MyColors().purple,
            ),
          ),
        ),
        margin: EdgeInsets.only(top: 15),
        padding: EdgeInsets.only(bottom: 10),
        child: Text(
          _selectedItem == null ? widget.defaultValue : _selectedItem!,
          style: GoogleFonts.roboto(
            fontSize: 16,
            color: _selectedItem == null
                ? MyColors().purpleSixtyPercent
                : MyColors().purple,
          ),
        ),
      ),
    );
  }
}
