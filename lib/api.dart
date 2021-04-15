import 'package:dio/dio.dart';
import 'activity.dart';

Future<Response> getToDo() async {
  try {
    var response = await Dio().get('https://8zc8b4woh8.execute-api.us-east-2.amazonaws.com/staging/todo');
    if(response.statusCode == 200) {
      return response;
    }
    else{
      print('${response.statusCode} : ${response.data.toString()}');
      throw response.statusCode;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

void postActivity(String title, String desc){
    try{
      var response = Dio().post('https://8zc8b4woh8.execute-api.us-east-2.amazonaws.com/staging/todo',data: {'title':title,'description':desc});
    }
    catch (e){
      print(e);
      return null;
    }
}

void deleteActivity(String id){
  try{
    var response = Dio().delete('https://8zc8b4woh8.execute-api.us-east-2.amazonaws.com/staging/todo/'+id);
  }
  catch (e){
    print(e);
    return null;
  }
}

void editActivity(String id, String title, String desc){
  try{
    var response = Dio().put('https://8zc8b4woh8.execute-api.us-east-2.amazonaws.com/staging/todo',data: {'title':title,'description':desc,'id':id});
  }
  catch (e){
    print(e);
    return null;
  }
}