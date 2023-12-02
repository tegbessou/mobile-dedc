class Participant {
  String iri;
  int id;
  String? name;

  Participant({
    required this.iri,
    required this.id,
    this.name,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    final Participant participant = Participant(
      iri: json['@id'],
      id: json['id'] as int,
    );

    if (json.containsKey("name")) {
      participant.name = json["name"];
    }

    print(participant);

    return participant;
  }
}