import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/extensions/extensions.dart';

class LableTextField extends StatefulWidget {
  final String lableText;
  final TextEditingController controller;
  final bool isDropDown;
  final List<String>? dropdownList;
  final bool isMultiselect;
  final Function(List<String>)? updateselectedItems;
  final int? maxLength;
  final String? characterAllowed;
  final bool dropdownAlwaysOpen;
  final bool hideInput;
  const LableTextField(
      {Key? key,
      required this.lableText,
      required this.controller,
      this.isDropDown = false,
      this.dropdownList,
      this.isMultiselect = false,
      this.updateselectedItems,
      this.maxLength,
      this.dropdownAlwaysOpen = false,
      this.characterAllowed,
      this.hideInput = false})
      : super(key: key);

  @override
  State<LableTextField> createState() => _LableTextFieldState();
}

class _LableTextFieldState extends State<LableTextField> {
  bool isDropDownOpen = false;
  FocusNode focusNode = FocusNode();
  List<String> selecteditems = [];
  List<String> suggetionList = [];
  bool obsucreText = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isDropDownOpen = widget.dropdownAlwaysOpen;

    if (widget.dropdownAlwaysOpen) {
      focusNode.addListener(() {
        if (focusNode.hasFocus) {
          isDropDownOpen = true;
        } else {
          isDropDownOpen = false;
        }
      });
    }

    if (widget.isDropDown && widget.dropdownList != null) {
      suggetionList = widget.dropdownList!;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: TextField(
            obscureText: widget.hideInput ? obsucreText : false,
            controller: widget.controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              suffixIcon: widget.isDropDown && widget.dropdownList!.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          isDropDownOpen = !isDropDownOpen;
                        });
                      },
                      child: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey,
                      ),
                    )
                  : widget.hideInput
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              obsucreText = !obsucreText;
                            });
                          },
                          child: Icon(
                            obsucreText
                                ? Icons.visibility_off
                                : Icons.remove_red_eye,
                            color: Color(0xffC9C9C9),
                            size: 20,
                          ),
                        )
                      : null,
              labelText: widget.lableText,
              labelStyle: TextStyle(
                  color: const Color(0xffC9C9C9),
                  fontFamily: 'gilroy-semibold',
                  fontSize: 1.2 / 100 * width,
                  letterSpacing: 1.5),
              // hintText: '',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(
                  color: Color(0xffC9C9C9),
                  width: 1.3, // Adjust the width as needed
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                // Adding focused border to have consistent border appearance
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(
                  color: Color(0xffC9C9C9),
                  width: 1.3, // Adjust the width as needed
                ),
              ),
            ),
            style: TextStyle(
                fontFamily: 'gilroy-bold',
                fontSize: 1.3 / 100 * width,
                letterSpacing: 1.3),
            onChanged: (text) {
              if (widget.isDropDown && widget.dropdownList != null) {
                if (text.isEmpty) {
                  suggetionList = widget.dropdownList!;
                } else {
                  suggetionList = applyFilterToDropDownSuggestions(
                      widget.dropdownList!, text);
                }
                setState(() {});
              }
            },
            inputFormatters: [
              if (widget.maxLength != null) ...[
                LengthLimitingTextInputFormatter(widget.maxLength)
              ],
            ],
          ),
        ),
        if ((widget.isDropDown) && widget.dropdownList != null) ...[
          isDropDownOpen && widget.dropdownList!.isNotEmpty
              ? Container(
                  height: 19 / 100 * height,
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: const Color(0xffC9C9C9),
                    width: 1.3,
                  )),
                  child: ListView.builder(
                    itemCount: suggetionList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (widget.isMultiselect &&
                              widget.updateselectedItems != null) {
                            if (selecteditems.contains(suggetionList[index])) {
                              selecteditems.remove(suggetionList[index]);
                            } else {
                              if (selecteditems.length < 5) {
                                selecteditems.add(suggetionList[index]);
                              }
                            }
                            widget.updateselectedItems!(selecteditems);
                            isDropDownOpen = true;
                            setState(() {});
                          } else {
                            setState(() {
                              widget.controller.text = suggetionList[index];
                            });
                          }
                        },
                        child: Text(
                          suggetionList[index],
                          style: TextStyle(
                              color: widget.isMultiselect &&
                                      selecteditems
                                          .contains(suggetionList[index])
                                  ? Colors.red
                                  : const Color(0xff9B9B9B),
                              fontFamily: 'gilroy-semibold',
                              fontSize: 1.5 / 100 * width),
                        ).addVerticalMargin(8),
                      );
                    },
                  ).addLeftMargin(10),
                )
              : SizedBox(
                  height: 19 / 100 * height,
                ),
        ]
      ],
    );
  }

  List<String> applyFilterToDropDownSuggestions(
      List<String> items, String query) {
    if (query == '') {
      return items;
    }
    print('Filter applying');
    return items
        .where((e) => e.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
  }
}
