import 'activity.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'package:dio/dio.dart';

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

class _MyHomePageState extends State<MyHomePage> {
  var _activityList = <Activity>[];

  @override
  void initState()  {
    super.initState();
    getToDo().then((value){
      setState(() {
        value.data.forEach((elem){
          _activityList.add(Activity.fromJson(elem));
        });
      });
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _refresh(),
        builder: (context,snapshot){
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
        });
  }

  Widget _listWidget(){
    return RefreshIndicator(
        child: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemBuilder: (context,i){
            if (_activityList != null){
              if(i < _activityList.length)
                return Card(child: _activityListBuilder(_activityList[i]),);
            }
            return null;
          },
        ),
        onRefresh: _refresh,
    );
  }

  Future<void> _refresh () async {
    var response = await getToDo();
    _activityList = [];
    setState(() {
    response.data.forEach((elem){
       _activityList.add(Activity.fromJson(elem));
     });
  });
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
                deleteActivity(item.id);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(item.nome + " removida"),
                    action: SnackBarAction(
                      label: 'Desfazer',
                      onPressed: (){
                        setState(() {
                          postActivity(item.nome,item.descricao);
                        });
                      },
                    ),));
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
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.article),
                onPressed: ()=> _editActivityWindow(item),
                tooltip: 'Edit Activity',
              ),
              appBar: AppBar(
                leading:
                    BackButton(color: Colors.white,onPressed: () => Navigator.pop(context)),
              ),
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

  void _editActivityWindow(Activity item){
    final _formKey = GlobalKey<FormState>();
    var _activityName = item.nome;
    var _activityDescription = item.descricao;
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
                          textCapitalization: TextCapitalization.sentences,
                          decoration: (InputDecoration(
                            hintText: item.nome,
                            labelText: "Nome da Tarefa",
                            icon: Icon(Icons.lightbulb_outline),
                          )
                          ),
                          onSaved: (String value){
                            if(value.isEmpty == false) _activityName = value;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                          minLines: 1,
                          maxLines: 6,
                          decoration: (InputDecoration(
                            hintText: item.descricao,
                            labelText: "Descrição da Tarefa",
                            icon: Icon(Icons.list_alt),
                          )
                          ),
                          onSaved: (String value){
                            if(value.isEmpty == false) _activityDescription = value;
                          },
                        ),
                        ElevatedButton(
                            onPressed: (){
                              if(_formKey.currentState.validate()){
                                _formKey.currentState.save();
                                editActivity(item.id,_activityName,_activityDescription);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text("Edição concluída")));
                                Navigator.pop(context);
                              }
                            },
                            child: Text("Editar atividade"))
                      ],
                    ),
                  )
              );
            })
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
                  textCapitalization: TextCapitalization.sentences,
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
                  textCapitalization: TextCapitalization.sentences,
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
                        postActivity(_activityName,_activityDescription);
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
