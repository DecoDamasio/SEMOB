
import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final int menuSelecionado;
  final ValueChanged<int> onMenuSelected;

  const SideMenu({
    super.key,
    required this.menuSelecionado,
    required this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      color: const Color(0xFF123F68),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 13, 8, 9),
            child: Text(
              'MENU PRINCIPAL',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 7,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          _item(
            0,
            Icons.grid_view_outlined,
            'Dashboard',
          ),

          _item(
            1,
            Icons.directions_bus_outlined,
            'Operação',
          ),

          _item(
            2,
            Icons.analytics_outlined,
            'Análises',
          ),

          _item(
            3,
            Icons.description_outlined,
            'Relatórios',
          ),

          const Spacer(),

          Container(
            padding: const EdgeInsets.fromLTRB(9, 10, 9, 10),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0x335F86A7),
                ),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sistema acadêmico de',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 7,
                  ),
                ),
                Text(
                  'acompanhamento da operação',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 7,
                  ),
                ),
                Text(
                  'municipal.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 7,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Versão demonstrativa 1.0',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(
    int index,
    IconData icon,
    String title,
  ) {
    final selected = menuSelecionado == index;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      child: Material(
        color: selected
            ? Colors.white
            : Colors.transparent,
        borderRadius: BorderRadius.circular(3),
        child: InkWell(
          borderRadius: BorderRadius.circular(3),
          onTap: () => onMenuSelected(index),
          child: SizedBox(
            height: 24,
            child: Row(
              children: [
                const SizedBox(width: 7),
                Icon(
                  icon,
                  size: 12,
                  color: selected
                      ? const Color(0xFF173F68)
                      : Colors.white,
                ),
                const SizedBox(width: 7),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: selected
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: selected
                        ? const Color(0xFF173F68)
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
