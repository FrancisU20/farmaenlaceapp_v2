import 'package:flutter/material.dart';

class BarraBusqueda extends StatefulWidget {
  final Function(String) onFilter;

  const BarraBusqueda({
    Key? key,
    required this.onFilter,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BarraBusquedaState createState() => _BarraBusquedaState();
}

class _BarraBusquedaState extends State<BarraBusqueda> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _clearSearch() {
    setState(() {
      _controller.clear();
    });
    widget.onFilter('');
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            textInputAction: TextInputAction.search,
            onChanged: widget.onFilter,
            style: const TextStyle(color: Colors.indigo),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color.fromARGB(106, 176, 190, 197),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        SizedBox(
          width: 50,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.redAccent,
            ),
            child: IconButton(
              icon: const Icon(Icons.clear_all),
              color: Colors.white,
              onPressed: _clearSearch,
            ),
          ),
        ),
      ],
    );
  }
}
