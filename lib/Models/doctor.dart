class Doctor {
  String name;
  String degree;
  String servicesProvided;
  String address;
  double latitude;
  double longitude;
  double ratings;

  Doctor(
      {this.name,
      this.degree,
      this.servicesProvided,
      this.address,
      this.latitude,
      this.longitude,
      this.ratings});

  Doctor.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    degree = json['degree'];
    servicesProvided = json['services_provided'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    ratings = json['ratings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['degree'] = this.degree;
    data['services_provided'] = this.servicesProvided;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['ratings'] = this.ratings;
    return data;
  }
}