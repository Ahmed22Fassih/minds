

import 'dart:developer';

class TodoModelResponse {
  List<Todos>? todos;
  int? total;
  int? skip;
  int? limit;

  TodoModelResponse({todos, total, skip, limit});

  TodoModelResponse.fromJson(Map<String, dynamic> json) {
    if (json['todos'] != null) {
      todos = <Todos>[];
      json['todos'].forEach((v) {
        todos!.add(Todos.fromJson(v));
      });
    }
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (todos != null) {
      data['todos'] = todos!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['skip'] = skip;
    data['limit'] = limit;
    return data;
  }
}

class Todos {
  int? id;
  String? todo;
  dynamic completed;
  int? userId;

  Todos({id, todo, completed, userId});

  Todos.fromJson(Map<String, dynamic> json) {
    log("json['completed']${json['completed'].runtimeType}");
    id = json['id'];
    todo = json['todo'];
    completed = json['completed'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['todo'] = todo;
    data['completed'] = completed;
    data['userId'] = userId;
    return data;
  }
}
