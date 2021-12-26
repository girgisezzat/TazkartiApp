import 'package:tazkarti_app/models/tazkarti_app/match_model.dart';

class ReservationModel{
  String? userID;
  String? matchId;
  int? numOfTickets;
  double? totalPrice;
  MatchModel? matchModel;

  ReservationModel({
    required this.userID,
    required this.matchId,
    required this.numOfTickets,
    required this.totalPrice,
    this.matchModel,
  });

  ReservationModel.fromJson(Map<String, dynamic>json){
    userID = json['userID'];
    matchId = json['matchId'];
    numOfTickets = json['numOfTickets'];
    totalPrice = json['totalPrice'];
  }

  Map<String, dynamic> toMap(){
    return {
      'matchId':matchId,
      'numOfTickets':numOfTickets,
      'totalPrice':totalPrice,
    };
  }
}
