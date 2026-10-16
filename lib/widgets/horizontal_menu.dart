import 'package:flutter/material.dart';

class HorizontalMenu extends StatelessWidget {
  final List<String> menus;
  final int menuSelecionado;
  final ValueChanged<int> onMenuSelecionado;

  const HorizontalMenu({
    super.key,
    required this.menus,
    required this.menuSelecionado,
    required this.onMenuSelecionado,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE0E6ED),
          ),
        ),
      ),
      child: Row(
        children: List.generate(
          menus.length,
          (index) {
            final selecionado = index == menuSelecionado;

            return InkWell(
              onTap: () {
                onMenuSelecionado(index);
              },
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: selecionado
                          ? const Color(0xFF1554C0)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  menus[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: selecionado
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: selecionado
                        ? const Color(0xFF1554C0)
                        : const Color(0xFF526985),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}