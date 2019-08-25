import 'package:rxbloc/src/rxbloc.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  final sampleBloc = SampleBloc();
  sampleBloc.sampleStream
      .map((value) => "Value: $value")
      .listen(print)
      .onDone(() {
    print("Stream closed");
  });
  RxBloc rxBloc = new RxBloc();
  rxBloc.update(sampleBloc.sampleStream).add(123);
  sampleBloc.work();
  sampleBloc.dispose();
}

class SampleBloc {
  RxBloc _rxBloc = RxBloc();
  BlocStream<int> sampleStream;
  BlocStream<String> stringStream;

  SampleBloc() {
    sampleStream = _rxBloc.behaviour<int>();
    stringStream = _rxBloc.behaviour<String>();
  }

  void work() {
    _rxBloc.update(sampleStream).add(123);
  }

  void dispose() {
    _rxBloc.close();
  }
}
