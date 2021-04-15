class Activity {
  var nome;
  var descricao;
  var saved;
  var id;

  Activity(String nomeIn,String descricaoIn){
    nome = nomeIn;
    descricao = descricaoIn;
    saved = false;
  }

  void setId(String idIn){
    this.id = idIn;
  }

  factory Activity.fromJson(Map<String,dynamic> json) {
    var item = Activity(json["title"], json['description']);
    item.setId(json['id']);
    return item;
  }

  Map<String,dynamic> toJson() => {
    "title": nome,
    "description": descricao,
    "id": id,
  };

}