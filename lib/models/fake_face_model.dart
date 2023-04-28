class FakeFace {
  String? url;
  String? fileName;

  FakeFace({
    this.url,
  });

  FakeFace.fromJson(Map<String, dynamic> json) {

    String file = json['url'] ?? '';

    if(json['url'] != null) {
      file = file.split('/').last;
    }
    url = json['url'] ?? '';
    fileName = file;
  }
}
