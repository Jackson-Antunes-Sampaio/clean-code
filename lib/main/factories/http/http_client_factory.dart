import 'package:http/http.dart';

import '../../../data/http/http.dart';
import '../../../infra/http/http.dart';


HttpClient makeHttpAdapter(){

  final Client client = Client();

  return HttpAdapter(client: client);

}