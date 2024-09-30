class DatePerson {
  String uid;
  String name;
  String profile;
  String cover;
  String status; // Cambiado a "status"
  String search;
  String facebook;
  String instagram;
  String dd;
  String mm;
  String aaaa;
  String program;

  DatePerson({
    required this.uid,
    required this.name,
    required this.profile,
    required this.cover,
    required this.status, // Cambiado a "status"
    required this.search,
    required this.facebook,
    required this.instagram,
    required this.dd,
    required this.mm,
    required this.aaaa,
    required this.program,
  });

  // Método para crear una instancia de DatePerson desde un JSON
  factory DatePerson.fromJson(Map<String, dynamic> json) {
    return DatePerson(
      uid: json['uid'],
      name: json['name'],
      profile: json['profile'],
      cover: json['cover'],
      status: json['status'], // Cambiado a "status"
      search: json['search'],
      facebook: json['facebook'],
      instagram: json['instagram'],
      dd: json['dd'],
      mm: json['mm'],
      aaaa: json['aaaa'],
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
      'status': status, // Cambiado a "status"
      'search': search,
      'facebook': facebook,
      'instagram': instagram,
      'dd': dd,
      'mm': mm,
      'aaaa': aaaa,
      'program': program,
    };
  }
}
