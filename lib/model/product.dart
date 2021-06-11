class ProductData {
  String _name;
  String _description;
  int _price;
  int _stock;
  String _imageBig;
  String _imageSmall;

  ProductData() {
    _name = "";
    _description = "";
    _price = 1;
    _stock = 1;
    _imageBig = "";
    _imageSmall = "";
  }

  ProductData.fromMap(map) {
    this._name = map["name"];
    this._description = map["description"];
    this._price = map["price"];
    this._stock = map["stock"];
    this._imageBig = map["imageBig"];
    this._imageSmall = map["imageSmall"];
  }

  String get name => _name;
  String get description => _description;
  int get price => _price;
  int get stock => _stock;
  String get imageBig => _imageBig;
  String get imageSmall => _imageSmall;

  set name(String newName) {
    if (newName.length > 0) {
      this._name = newName;
    }
  }

  set description(String newDescription) {
    if (newDescription.length > 0) {
      this._description = newDescription;
    }
  }

  set price(int newPrice) {
    if (newPrice > 0 && newPrice < 4) {
      this._price = newPrice;
    }
  }

  set stock(int newStock) {
    if (newStock > 0) {
      this._stock = newStock;
    }
  }

  set imageBig(String newImageBig) {
    if (newImageBig.length > 0) {
      this._imageBig = newImageBig;
    }
  }

  set imageSmall(String newImageSmall) {
    if (newImageSmall.length > 0) {
      this._imageSmall = newImageSmall;
    }
  }

  toMap() {
    var map = Map<String, dynamic>();
    map["name"] = _name;
    map["description"] = _description;
    map["price"] = _price;
    map["stock"] = _stock;
    map["imageBig"] = _imageBig;
    map["imageSmall"] = _imageSmall;
    return map;
  }
}