import 'package:flutter/material.dart';
import 'package:order_manager/core/theme/app_colors.dart';
import 'package:order_manager/core/theme/app_text_style.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String Function(T) getLabel; // Función para extraer el texto a mostrar
  final Color? color;

  const CustomDropdownButton({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.getLabel, 
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      decoration: BoxDecoration(
        color: color ?? const Color.fromRGBO(37, 167, 190, 100),
        // border: Border.all(color: const Color.fromARGB(255, 0, 0, 253), width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButton<T>(
        padding: const EdgeInsets.only(left: 10.0),
        // isDense: true,
        menuWidth: 180,
        // menuMaxHeight: 350.0,
        borderRadius: BorderRadius.circular(4.0),
        isExpanded: true,
        dropdownColor: AppColors.backgroundColor(context),// const Color.fromARGB(255, 247, 247, 247),
        value: value,
        icon: Row(
          children: [
            Icon(Icons.arrow_drop_down, color: AppColors.textDropdown(context)),
            const SizedBox(
              width: 12.0,
            ),
          ],
        ),
        iconSize: 23.0,
        // elevation: 10,
        style: AppTextStyle(context)
                      .bold15(color: AppColors.textDropdown(context)),//AppTextStyle(context).bold13(color: AppColors.textBasic(context)),
        underline: Container(
          height: 0,
          color: AppColors.black,
        ),
        onChanged: onChanged,
         items: items.map<DropdownMenuItem<T>>((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(getLabel(item), maxLines: 2,overflow: TextOverflow.ellipsis,), // Extrae el texto dinámicamente
        );
      }).toList(),
      ),
    );
  }
}
 