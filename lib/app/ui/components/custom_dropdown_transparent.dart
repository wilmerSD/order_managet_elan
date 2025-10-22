import 'package:flutter/material.dart';
import 'package:order_manager/core/theme/app_colors.dart';
import 'package:order_manager/core/theme/app_text_style.dart';

class CustomDropdownTransparent<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String label;
  final String Function(T) getLabel; // Función para extraer el texto a mostrar

  const CustomDropdownTransparent({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
     required this.label,
    required this.getLabel,
  });

  @override
     Widget build(BuildContext context) {
  return SizedBox(
    height: 45.0, // un poco más alto para el label
    child: Stack(
      children: [
        // Contenedor con el Dropdown
        Container(
          margin: const EdgeInsets.only(top: 8.0), // para que el label no tape el borde
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grayLight, width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: DropdownButton<T>(
            padding: const EdgeInsets.only(left: 10.0),
            menuWidth: 180,
            borderRadius: BorderRadius.circular(4.0),
            isExpanded: true,
            dropdownColor: AppColors.backgroundColor(context),// const Color.fromARGB(255, 247, 247, 247),
            value: value,
            icon: Row(
              children: [
                Icon(Icons.keyboard_arrow_down, color: AppColors.primary(context)),
                const SizedBox(width: 12.0),
              ],
            ),
            iconSize: 23.0,
            elevation: 10,
            style: AppTextStyle(context)
                .bold13(color: AppColors.textBasic(context)),
            underline: Container(height: 0),
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<T>>((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  getLabel(item),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ),
        ),

        // Label flotante
        Positioned(
          left: 10,
          top: 0,
          child: Container(            
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor(context), // para tapar el borde debajo del texto
              borderRadius: BorderRadius.circular(2)
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textBasic(context),
              ),
            ),
          ),
        ),
      ],
    ),
  );
  }
}
 

