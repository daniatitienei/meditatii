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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        ),
        context: context,
        builder: (context) => Container(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  onChanged: (value) => _runFilter(value),
                  controller: _searchController,
                  cursorColor: MyColors().purple,
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(color: MyColors().purple),
                  ),
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: MyColors().purple,
                    ),
                    hintText: 'Scrieti aici',
                    hintStyle: GoogleFonts.montserrat(
                      color: MyColors().purpleSixtyPercent,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 15),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      widget.callBack(_foundSearches[index]);

                      setState(() {
                        _selectedItem = _foundSearches[index];
                      });

                      Navigator.of(context).pop();
                    },
                    leading: Text(
                      _foundSearches[index],
                      style: GoogleFonts.montserrat(),
                    ),
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
          style: GoogleFonts.montserrat(
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
