import 'package:clean_arch/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          onSubmitted: (_) => _dispatchConcrete(),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                child: const Text('Search'),
                onPressed: _dispatchConcrete,
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: ElevatedButton(
                child: const Text('Get random trivia'),
                onPressed: _dispatchRandom,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _dispatchConcrete() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForConcreteNumber(_controller.text));
    _controller.clear();
  }

  void _dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}
