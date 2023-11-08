class Animal {
  String imageURL = "";
  String animaltype = "";
  String informacion = "";
  String infoubicacion = "";
  String recompensa = "";
  String numref = "";
  String status = "Perdido";
  Animal({
    required this.imageURL,
    required this.animaltype,
    required this.informacion,
    required this.infoubicacion,
    required this.recompensa,
    required this.numref,
  });

  Map<String, dynamic> get ToMap {
    return {
      "imageURL": this.imageURL,
      "animaltype": this.animaltype,
      "informacion": this.informacion,
      "infoubicacion": this.infoubicacion,
      "recompensa": this.recompensa,
      "numref": this.numref,
      "status": "Perdido"
    };
  }
}
