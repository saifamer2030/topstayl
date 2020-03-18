import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topstyle/helper/appLocalization.dart';
import 'package:topstyle/providers/languages_provider.dart';
import 'package:topstyle/providers/search_provider.dart';
import 'package:topstyle/screens/product_details.dart';
import 'package:topstyle/widgets/adaptive_progress_indecator.dart';

class SearchProduct extends SearchDelegate<SearchModel> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.close),
      ),
    ];
  }

  AppLanguageProvider _languageProvider = AppLanguageProvider();

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ExerciseList(
      query: query,
      lang: _languageProvider.fetchLocale().toString(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return query == ''
        ? Container()
        : ExerciseList(
            query: query,
            lang: _languageProvider.fetchLocale().toString(),
          );
  }
}

class ExerciseList extends StatelessWidget {
  final String query;
  final String lang;

  const ExerciseList({this.query, this.lang, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SearchModel>>(
      future: Provider.of<SearchProvider>(context, listen: false)
          .search(query, lang),
      builder: (context, AsyncSnapshot<List<SearchModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, position) {
                return ListTile(
                  leading: Image.network(
                    snapshot.data[position].image,
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.fill,
                  ),
                  title: Text(snapshot.data[position].name),
                  onTap: () {
                    print(snapshot.data[position].id);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ProductDetails(snapshot.data[position].id)));
                  },
                );
              },
            );
          } else {
            return Center(
              child: Text(AppLocalization.of(context)
                  .translate('no_products_for_your_search')),
            );
          }
        } else {
          return Center(
            child: AdaptiveProgressIndicator(),
          );
        }
      },
    );
  }
}
