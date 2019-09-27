import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_annotations/core/bloc/object_event.dart';
import 'package:flutter_annotations/core/bloc/object_state.dart';
import 'package:flutter_annotations/core/bloc/search_bloc.dart';
import 'package:flutter_annotations/core/model/domain/anotation.dart';
import 'package:flutter_annotations/ui/widget/annotation_item.dart';
import 'package:flutter_annotations/utils/Translations.dart';
import 'package:flutter_annotations/utils/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchAnnotationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
        builder: (context) => SearchBloc(),
        child: BlocBuilder<SearchBloc, ObjectState>(
            builder: (context, objectState) {
          print('objectState ${objectState}');
          return SearchAnnotationView();
        }));
  }
}

class SearchAnnotationView extends StatefulWidget {
  SearchAnnotationView();

  @override
  _SearchAnnotationView createState() => _SearchAnnotationView();
}

class _SearchAnnotationView extends State<SearchAnnotationView>
    with SingleTickerProviderStateMixin {
  SearchBloc _searchBloc;
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();
  TextEditingController _searchQuery;
  bool _isSearching = false;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchBloc = BlocProvider.of<SearchBloc>(context);
    _searchBloc.dispatch(Run());
    _searchQuery = new TextEditingController();
    setState(() {
      _isSearching = true;
    });
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    print("close search box");
    setState(() {
      _searchQuery.clear();
      updateSearchQuery("");
    });
  }

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment =
        Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return new InkWell(
      onTap: () => scaffoldKey.currentState.openDrawer(),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            Text('${Translations.current.text('search_annotation')}'),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    var hintText = Translations.current.text('search_annotation');
    return new TextField(
      onSubmitted: (value) {},
      textInputAction: TextInputAction.search,
      controller: _searchQuery,
      autofocus: true,
      decoration: InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
        hintStyle: TextStyle(color: Styles.titleColor.withOpacity(0.5)),
      ),
      style: TextStyle(color: Styles.titleColor, fontSize: 16.0),
      onChanged: updateSearchQuery,
    );
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
    _searchBloc.updateQueryValue(newQuery);
    print("search query " + newQuery);
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      new IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      key: scaffoldKey,
      appBar: new AppBar(
        leading: _isSearching ? const BackButton() : null,
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        actions: _buildActions(),
      ),
      body: BlocBuilder<SearchBloc, ObjectState>(
        builder: (context, objectState) {
          print('_home:objectState => ${objectState}');

          if (objectState is ObjectLoaded) {
            var objectLoaded = (objectState as ObjectLoaded);
            if (objectState.objects.isEmpty) {
              return Center(
                child: Text(
                  '${Translations.current.text('no_notes_found')} {${searchQuery}}',
                  style: Styles.styleDescription(color: Styles.subtitleColor),
                ),
              );
            }
            return Container(
              margin: EdgeInsets.only(top: 16.0),
              child:  ListView.builder(
                  itemCount: objectLoaded.objects.length,
                  itemBuilder: (context, index) {
                    var anotation = (objectLoaded.objects[index] as Annotation);
                    return ASearchItem(
                      key: Key('${anotation.title}'),
                      anotation: anotation,
                      onTap: () {
                        Navigator.pushNamed(context, '/openAnnotation',
                            arguments: (objectLoaded.objects[index] as Annotation));
                      },
                    );
                  }),
            );
          }

          return Center(
            child: Text(
                '${Translations.current.text('no_notes_found')} {${searchQuery}}'),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
