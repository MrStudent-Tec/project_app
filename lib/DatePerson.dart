class DatePerson {
  String uid;
  String name;
  String profile;
  String cover;
  String status;
  String search;
  String facebook;
  String instagram;
  DateTime birthdate; // Cambiado a DateTime
  String program;

  DatePerson({
    required this.uid,
    required this.name,
    required this.profile,
    required this.cover,
    required this.status,
    required this.search,
    required this.facebook,
    required this.instagram,
    required this.birthdate, // Cambiado a DateTime
    required this.program,
  });

  // Método para crear una instancia de DatePerson desde un JSON
  factory DatePerson.fromJson(Map<String, dynamic> json) {
    return DatePerson(
      uid: json['uid'],
      name: json['name'],
      profile: json['profile'],
      cover: json['cover'],
      status: json['status'],
      search: json['search'],
      facebook: json['facebook'],
      instagram: json['instagram'],
      birthdate:
          DateTime.parse(json['birthdate']), // Convierte el string a DateTime
      program: json['program'],
    );
  }

  // Método para convertir una instancia de DatePerson a JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'profile': profile,
      'cover': cover,
      'status': status,
      'search': search,
      'facebook': facebook,
      'instagram': instagram,
      'birthdate':
          birthdate.toIso8601String(), // Convierte DateTime a string ISO 8601
      'program': program,
    };
  }
}
