class Refresher {
  final List<Function> _setStates = [];

  Refresher();

  void add(Function setState) => _setStates.add(setState);

  void refresh() {
    for (Function setState in _setStates) {
      setState();
    }
  }
}
