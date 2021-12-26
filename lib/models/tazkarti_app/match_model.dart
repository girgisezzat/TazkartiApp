class MatchModel {

  String? matchId;
  String? firstTeamName;
  String? secondTeamName;
  String? stadiumName;
  String? uId;
  String? matchDate;
  String? matchTime;
  String? logoFirstTeam;
  String? logoSecondTeam;
  String? stadiumLogo;
  String? ticketNumbers;
  String? ticketPrice;
  DateTime? date;
  bool? isPublished;
  int? nomOfReservedTickets;


  MatchModel({
    this.matchId,
    this.firstTeamName,
    this.secondTeamName,
    this.stadiumName,
    this.uId,
    this.matchDate,
    this.matchTime,
    this.logoFirstTeam,
    this.logoSecondTeam,
    this.stadiumLogo,
    this.ticketNumbers,
    this.ticketPrice,
    this.date,
    this.isPublished,
    this.nomOfReservedTickets,
  });

  MatchModel.fromJson(Map<String,dynamic>json)
  {
    matchId = json['matchId'];
    firstTeamName = json['firstTeamName'];
    secondTeamName = json['secondTeamName'];
    stadiumName = json['stadiumName'];
    uId = json['uId'];
    matchDate = json['matchDate'];
    matchTime = json['matchTime'];
    logoFirstTeam = json['logoFirstTeam'];
    logoSecondTeam = json['logoSecondTeam'];
    stadiumLogo = json['stadiumLogo'];
    ticketNumbers = json['ticketNumbers'];
    ticketPrice = json['ticketPrice'];
    isPublished = json['isPublished'];
    nomOfReservedTickets = json['nomOfReservedTickets'];
  }
  Map<String, dynamic> toMap()
  {
    return {
      'matchId': matchId,
      'firstTeamName': firstTeamName,
      'secondTeamName': secondTeamName,
      'stadiumName': stadiumName,
      'uId': uId,
      'matchDate': matchDate,
      'matchTime': matchTime,
      'logoFirstTeam': logoFirstTeam,
      'logoSecondTeam': logoSecondTeam,
      'stadiumLogo': stadiumLogo,
      'ticketNumbers': ticketNumbers,
      'ticketPrice': ticketPrice,
      'date': date,
      'isPublished': isPublished,
      'nomOfReservedTickets': nomOfReservedTickets,
    };
  }
}