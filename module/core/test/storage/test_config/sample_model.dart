class SampleModel {
  SampleModel({
    required this.id,
    required this.data,
  });

  SampleModel.empty()
      : id = '',
        data = '';

  factory SampleModel.fromJson(dynamic json) {
    if (json == null) {
      return SampleModel.empty();
    }
    if (json is! Map) {
      return SampleModel.empty();
    }
    if (json is! Map<String, dynamic>) {
      return SampleModel.empty();
    }

    final id = json['id'];
    if (id == null) {
      return SampleModel.empty();
    }
    if (id is! String) {
      return SampleModel.empty();
    }

    final data = json['data'];
    if (data == null) {
      return SampleModel.empty();
    }
    if (data is! String) {
      return SampleModel.empty();
    }

    return SampleModel(
      id: id,
      data: data,
    );
  }

  final String id;
  final String data;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data,
    };
  }

  @override
  String toString() {
    return 'SampleModel{id: $id, data: $data}';
  }
}
