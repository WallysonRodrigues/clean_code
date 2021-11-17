import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injector_container.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        child: _buildyBody(context),
      ),
    );
  }

  BlocProvider<NumberTriviaBloc> _buildyBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return const MessageDisplay(
                      message: 'Start Searching',
                    );
                  }

                  if (state is Loading) {
                    return const LoadingWidget();
                  }

                  if (state is Loaded) {
                    return TriviaDisplay(
                      numberTrivia: state.trivia,
                    );
                  }

                  if (state is Error) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  }

                  return Container();
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              const TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}
