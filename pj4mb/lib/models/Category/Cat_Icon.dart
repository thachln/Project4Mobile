class Cat_Icon{
  final int id;
  final String path;

  Cat_Icon({required this.id,required this.path});

  factory Cat_Icon.fromJson(Map<String, dynamic> json) {
    return Cat_Icon(
      id: json['id'],
      path: json['path'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'path': path,
  };
}