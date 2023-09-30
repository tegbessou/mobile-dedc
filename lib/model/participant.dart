class Participant {
  String iri;
  int id;
  String name;

  Participant({
    required this.iri,
    required this.id,
    required this.name,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      iri: json['@id'],
      id: json['id'] as int,
      name: json['name'],
    );
  }
}