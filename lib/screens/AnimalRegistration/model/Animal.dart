class Animal {
  String imageURL;
  String animaltype;
  String informacion;
  String infoubicacion;
  String recompensa;
  String numref;
  String status = "Perdido";
  String userId;
  Animal({
    this.imageURL="",
    this.animaltype="",
    this.informacion="",
    this.infoubicacion="",
    this.recompensa="",
    this.numref="",
    this.userId=""
  });

  Map<String, dynamic> get toMap {
    return {
      "imageURL": this.imageURL,
      "animaltype": this.animaltype,
      "informacion": this.informacion,
      "infoubicacion": this.infoubicacion,
      "recompensa": this.recompensa,
      "numref": this.numref,
      "userId": this.userId,
      "status": "Perdido"
    };
  }
}
