import '../../factories.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

// LoginPresenter makeStreamLoginPresenter() {
//   return StreamLoginPresenter(
//       authentication: makeRemoveAuthentication(),
//       validation: makeLoginValidation());
// }

SurveysPresenter makeGetxSurveysPresenter() {
  return GetxSurveysPresenter(
  loadSurveys: makeRemoteLoadSurveys()
  );
}
