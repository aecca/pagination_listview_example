abstract class Provider {
  Future<List<String>> listItems({int page, int total});
}

class MemoryProvider extends Provider {

  @override
  Future<List<String>> listItems({int page, int total}) async {
    // simulate http delay
    await Future.delayed(Duration(milliseconds: 100));
    return new List<String>.generate(total, (i) => '$i');
  }

}
