import 'package:bloodlife/models/healthchannelheadlinesmodel.dart';
import 'package:bloodlife/repository/news_repository.dart';

class NewsViewModel {
  final _rep = NewsRepository();

  Future<healthchannelsmodels> fetchnewschannelheadlinesapi() async {
    final response = await _rep.fetchnewschannelheadlinesapi();
    return response;
  }
}
