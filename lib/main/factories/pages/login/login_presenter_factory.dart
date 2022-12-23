import '../../factories.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

// LoginPresenter makeStreamLoginPresenter() {
//   return StreamLoginPresenter(
//       authentication: makeRemoveAuthentication(),
//       validation: makeLoginValidation());
// }

LoginPresenter makeGetxLoginPresenter() {
  return GetxLoginPresenter(
    authentication: makeRemoteAuthentication(),
    validation: makeLoginValidation(),
    saveCurrentAccount: makeLocalSaveCurrentAccount()
  );
}
