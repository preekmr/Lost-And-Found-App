
class Item {
  int id;
  String name;
  String shape;
  String color;
  String owner;
  String date_found;
  String location_found;
  String file_name;
  bool is_collected;
  String date_collected;
  String collected_by;

  Item(this.name, this.shape, this.color, this.owner, this.date_found, this.location_found);

Item.fromJSON(Map<String, dynamic> jsonMap) :
    id = jsonMap['id'],
    name = jsonMap['name'],
    color = jsonMap['color'],
    shape = jsonMap['shape'],
    owner = jsonMap['owner'],
    date_found = jsonMap['date_found'],
    location_found = jsonMap['location_found'],
    file_name = jsonMap['file_name'],
    is_collected = jsonMap['is_collected'],
    date_collected = jsonMap['date_collected'],
    collected_by = jsonMap['collected_by'];

Map<String, dynamic> toJson() =>
    {
      'name': this.name,
      'owner': this.owner,
      'shape': this.shape,
      'color': this.color,
      'date_found': this.date_found,
      'location_found': this.location_found
    };
}