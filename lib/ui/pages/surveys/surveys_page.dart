import '../../../ui/pages/pages.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'components/survey_items.dart';


class SurveysPage extends StatefulWidget {
  const SurveysPage(this.presenter, {Key? key}) : super(key: key);
  final SurveysPresenter presenter;

  @override
  State<SurveysPage> createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage> with LoadingManager, NavigationManager, SessionManager, RouteAware {


  @override
  void didPopNext() {
    widget.presenter.loadData();
  }

  @override
  void dispose() {
    Get.find<RouteObserver>().unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.find<RouteObserver>().subscribe(this, ModalRoute.of(context) as PageRoute);
    return Scaffold(
      appBar: AppBar(title: Text(R.string.surveys)),
      body: Builder(
        builder: (context) {
          handleLoading(context, widget.presenter.isLoadingStream);
          handleSessionExpired(widget.presenter.isSessionExpiredStream);
          handleNavigation(widget.presenter.navigateToStream);
          widget.presenter.loadData();

          return StreamBuilder<List<SurveyViewModel>>(
              stream: widget.presenter.surveysStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ReloadScreen(error: '${snapshot.error}', reload: widget.presenter.loadData);
                }
                if (snapshot.hasData) {
                  return ListenableProvider(
                      create: (_) => widget.presenter,

                      child: SurveyItems(snapshot.data!)
                  );
                }
                return SizedBox(height: 0);
              }
          );
        },
      ),
    );
  }
}