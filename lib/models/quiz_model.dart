class QuizModel {
  QuizModel({
      this.quiz,});

  QuizModel.fromJson(dynamic json) {
    if (json['quiz'] != null) {
      quiz = [];
      json['quiz'].forEach((v) {
        quiz?.add(Quiz.fromJson(v));
      });
    }
  }
  List<Quiz>? quiz;
QuizModel copyWith({  List<Quiz>? quiz,
}) => QuizModel(  quiz: quiz ?? this.quiz,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (quiz != null) {
      map['quiz'] = quiz?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Quiz {
  Quiz({
      this.id, 
      this.question, 
      this.options, 
      this.answer, 
      this.image, 
      this.music, 
      this.quizType, 
      this.status, 
      this.isDelete, 
      this.createdAt, 
      this.updatedAt, 
      this.dateTime, 
      this.answers,});

  Quiz.fromJson(dynamic json) {
    id = json['id'];
    question = json['question'];
    options = json['options'];
    answer = json['answer'];
    image = json['image'];
    music = json['music'];
    quizType = json['quiz_type'];
    status = json['status'];
    isDelete = json['is_delete'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    dateTime = json['date_time'];
    answers = json['answers'] != null ? json['answers'].cast<String>() : [];
  }
  num? id;
  String? question;
  String? options;
  num? answer;
  String? image;
  String? music;
  num? quizType;
  num? status;
  num? isDelete;
  String? createdAt;
  String? updatedAt;
  String? dateTime;
  List<String>? answers;
Quiz copyWith({  num? id,
  String? question,
  String? options,
  num? answer,
  String? image,
  String? music,
  num? quizType,
  num? status,
  num? isDelete,
  String? createdAt,
  String? updatedAt,
  String? dateTime,
  List<String>? answers,
}) => Quiz(  id: id ?? this.id,
  question: question ?? this.question,
  options: options ?? this.options,
  answer: answer ?? this.answer,
  image: image ?? this.image,
  music: music ?? this.music,
  quizType: quizType ?? this.quizType,
  status: status ?? this.status,
  isDelete: isDelete ?? this.isDelete,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  dateTime: dateTime ?? this.dateTime,
  answers: answers ?? this.answers,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['question'] = question;
    map['options'] = options;
    map['answer'] = answer;
    map['image'] = image;
    map['music'] = music;
    map['quiz_type'] = quizType;
    map['status'] = status;
    map['is_delete'] = isDelete;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['date_time'] = dateTime;
    map['answers'] = answers;
    return map;
  }

}