import 'package:flutter/material.dart';
import 'package:flutter_course/src/features/menu/bloc/menu_bloc.dart';

class CartButton extends StatelessWidget {
  final MenuBloc bloc;

  const CartButton({
    super.key,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    final double totalCost = bloc.state.cartItems!.isEmpty
        ? 0.0
        : bloc.state.cartItems!
            .map<double>((e) => double.parse(e.prices[0].value))
            .reduce((value, element) => value + element);
    return Row(
      children: [
        const Icon(Icons.shopping_basket_outlined),
        const SizedBox(width: 10),
        Text('$totalCost RUB')
      ],
    );
  }
}
