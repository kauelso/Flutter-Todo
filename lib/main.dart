
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Atividades',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Lista de Atividades'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Activity {
  var nome;
  var descricao;
  var saved;

  Activity(String nomeIn,String descricaoIn){
    nome = nomeIn;
    descricao = descricaoIn;
    saved = false;
  }

}

class _MyHomePageState extends State<MyHomePage> {
  final _activityList = <Activity>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addActivityWindow,
        tooltip: 'New Activity',
        child: Icon(Icons.add),
      ),
      body: _listWidget(),
    );
  }

  Widget _listWidget(){
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context,i){

          if(i < _activityList.length) return Card(child: _activityListBuilder(_activityList[i]),);

          return null;


        },
    );
  }

  Widget _activityListBuilder(Activity item){
    return ListTile(
      title: Text(item.nome),
      onTap: ()=>_showDetails(item),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              item.saved ? Icons.check_box : Icons.check_box_outline_blank,
              color: item.saved ? Colors.green : Colors.grey,
            ),
            onPressed: (){
              setState(() {
                item.saved ? item.saved = false : item.saved = true;
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
            onPressed: (){
              setState(() {
                _activityList.remove(item);
              });
            },
          ),
        ],
      )
    );
  }

  void _showDetails(Activity item){
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context){
            return Scaffold(
              appBar: AppBar(leading: BackButton(color: Colors.white,onPressed: () => Navigator.pop(context)),),
              body: ListView(
                children: [
                  ListTile(
                    title: Text(item.nome, style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  ListTile(
                    title: Text(item.descricao, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),),
                  ),
                ],
              )
            );
          }
      )

    );
  }

  void _addActivityWindow(){
    final _formKey = GlobalKey<FormState>();
    var _activityName;
    var _activityDescription = "";
  Navigator.of(context).push(
  MaterialPageRoute(
      builder: (BuildContext context){
        return Scaffold(
          appBar: AppBar(title: Text("Nova Atividade",)),
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: (InputDecoration(
                    labelText: "Nome da Tarefa",
                    icon: Icon(Icons.lightbulb_outline),
                  )
                  ),
                  onSaved: (String value){
                    _activityName = value;
                  },
                  validator: (String value){
                    return (value == null || value.isEmpty ? "Campo Obrigatorio" : null);
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 6,
                  decoration: (InputDecoration(
                    labelText: "Descrição da Tarefa",
                    icon: Icon(Icons.list_alt),
                  )
                  ),
                  onSaved: (String value){
                    _activityDescription = value;
                  },
                ),
                ElevatedButton(
                    onPressed: (){
                      if(_formKey.currentState.validate()){
                        _formKey.currentState.save();
                        _activityList.add(new Activity(_activityName, _activityDescription));
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(_activityName + " adicionada")));
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Adicionar atividade"))
              ],
            ),
          )
        );
      })
  );
  }
}
