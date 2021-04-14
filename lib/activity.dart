class Activity {
  var nome;
  var descricao;
  var saved;
  var id;

  Activity(String nomeIn,String descricaoIn,String idIn){
    nome = nomeIn;
    descricao = descricaoIn;
    saved = false;
    id = idIn;
  }

  factory Activity.fromJson(Map<String,dynamic> json) => Activity(json["title"], json['description'], json['id']);

  Map<String,dynamic> toJson() => {
    "title": nome,
    "description": descricao,
    "id": id,
  };

}