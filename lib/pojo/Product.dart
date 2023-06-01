

class Product {
  int id;
  String code;
  String name;
  int price;

  Product(this.id, this.code, this.name, this.price);
  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'code': code,
      'name': name,
      'price': price,
    };
  }

}

