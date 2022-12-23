import 'package:curso_clean_solid/ui/pages/pages.dart';
import 'package:flutter/material.dart';

class SurveysItem extends StatelessWidget {
  const SurveysItem({Key? key, this.viewModel}) : super(key: key);

  final SurveyViewModel? viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: viewModel?.didAnswer == true ?  Theme.of(context).secondaryHeaderColor : Theme.of(context).primaryColorDark,
            boxShadow: const [
              BoxShadow(
                  offset: Offset(0, 1),
                  spreadRadius: 0,
                  blurRadius: 2,
                  color: Colors.black),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(10))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              viewModel?.date ?? '',
              style:const  TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 20,),
            Text(
              viewModel?.question ?? '',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24
              ),
            ),
          ],
        ),
      ),
    );
  }
}
