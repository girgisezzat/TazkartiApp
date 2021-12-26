import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



Widget defaultButton({
  double btnWidth = double.infinity,
  Color btnColor = Colors.blue,
  double? raduis = 0,
  bool? isUpperCase = true,
  required  Function()? function,
  required String text,

})
{
  return  Container(
    width: btnWidth,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(raduis!),
      color: btnColor,
    ),

    child: MaterialButton(
      onPressed: function,
      child: Text(
        isUpperCase! && isUpperCase ? text.toUpperCase() : text,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  );
}


Widget defaultTextFormField(
    {
      required TextEditingController? fieldController,
      required TextInputType? inputType,
      Function(String)? onSubmit,
      Function(String)? onChange,
      Function? onTap,
      required  String? Function(String?)? validator,
      required String? labelText,
      required IconData? prefixIcon,
      IconData? suffixIcon,
      bool obscureText = false,
      Function()? suffixClicked,
      double? raduis = 0,

    }) =>TextFormField(

  controller: fieldController,
  keyboardType: inputType,
  obscureText: obscureText,
  onFieldSubmitted: onSubmit,
  onChanged:onChange,
  validator: validator,
  onTap: (){
    onTap!();
  },
   decoration: InputDecoration(
    //hintText: "Password",
    labelText: labelText,
    prefixIcon: Icon(
        prefixIcon
    ),
    suffixIcon: IconButton(
        onPressed: suffixClicked,
        icon: Icon(suffixIcon)
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(raduis!),
    ),
  ),
);


Widget defaultTextButton({
  required  Function()? function,
  required String text,
}) =>
    TextButton(
      onPressed: function,
      child: Text(
        text.toUpperCase(),
      ),
    );


void navigateTo(context,Widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => Widget,
  ),
);

void navigateAndFinish(context,Widget) => Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (context) => Widget,
  ), (route){
    return false;
    },
);

Widget myDivider() => Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20.0,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);

Widget defaultAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
}) =>AppBar(
  leading: IconButton(
    onPressed: (){
      Navigator.pop(context);
    },
    icon: Icon(
      Icons.keyboard_arrow_left,
      size: 16.0,
    ),
  ),
  title: Text(
    title!,
  ),
  actions: actions,
);

void showToast({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

// enum
enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }

  return color;
}

Widget dropDownSearch({

  required List<String> dropDownList,
  required String? hint,
  double radius = 0,
  required GlobalKey<DropdownSearchState<String>> dropDownSearchKey,// as a controller
  required String? selectedItem,
  void Function(String?)? onChanged,
  required String? Function(String?)? validator,

})
{
  return DropdownSearch<String>(
    key: dropDownSearchKey,
    //mode of dropdown
    mode: Mode.MENU,
    //to show search box
    showSearchBox: true,
    items: dropDownList,

    dropdownSearchDecoration:  InputDecoration(
      hintText: hint,
      border:  OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
    ),

    validator: validator,
    onChanged: onChanged,

    //show selected item
    selectedItem: selectedItem,

  );
}