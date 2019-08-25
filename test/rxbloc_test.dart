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
  sampleBloc.work();
  sampleBloc.dispose();
}

class SampleBloc with RxBloc {
  RxUpdater _updater;
  BlocStream<int> sampleStream;
  BlocStream<String> stringStream;

  SampleBloc() {
    _updater = RxUpdater(this);
    sampleStream = BlocStream(this);
    stringStream = BlocStream(this);
  }

  void work() {
    _updater(sampleStream).add(31);
    _updater(sampleStream).add(32);
    _updater(sampleStream).add(33);
    _updater(sampleStream).add(33);
    _updater(sampleStream).close();
    _updater(stringStream).add('ok');
    _updater(stringStream);
  }

  void dispose() {
    this.close().then((_) {
      print("All stream closed");
    });
  }
}
