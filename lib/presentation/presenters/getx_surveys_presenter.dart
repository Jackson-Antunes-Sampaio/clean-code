import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usercases/usercases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSurveysPresenter extends GetxController implements SurveysPresenter{
  final _test = false.obs;
  final _navi = RxnString();

  final LoadSurveys loadSurveys;


  final _isLoading = true.obs;
  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;

  final _surveys = Rx<List<SurveyViewModel>>([]);
  @override
  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;

  GetxSurveysPresenter({required this.loadSurveys});

  @override
  Future<void> loadData()async{
    try{
      _isLoading.value = true;
      final surveys = await loadSurveys.load();
      _surveys.value = surveys.map((survey) => SurveyViewModel(
          id: survey.id,
          question: survey.question,
          date: DateFormat('dd MMM yyyy').format(survey.dateTime),
          didAnswer: survey.didAnswer)
      ).toList();
      _isLoading.value = false;
    }on DomainError{
      _surveys.addError(UIError.unexpected.description, StackTrace.empty);
    } finally{
      _isLoading.value = false;
    }

  }

  @override
  void goToSurveyResult(String surveyId) {
    // TODO: implement goToSurveyResult
  }

  @override
  // TODO: implement isSessionExpiredStream
  Stream<bool> get isSessionExpiredStream => _test.stream;

  @override
  // TODO: implement navigateToStream
  Stream<String?> get navigateToStream => _navi.stream;

}