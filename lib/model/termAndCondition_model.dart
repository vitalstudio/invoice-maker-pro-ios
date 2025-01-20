

class TermModel{
  int? id;
  String? tcDetail;

  TermModel({this.id,this.tcDetail});

  TermModel.fromMap(Map<String,dynamic> term):
        id = term['id'],
        tcDetail = term['tcDetail'];

  Map<String,Object?> toMap(){
    return{
      'id':id,
      'tcDetail':tcDetail,
    };
  }
}