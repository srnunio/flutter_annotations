import 'dart:io';

import 'package:anotacoes/core/model/enums/view_state.dart';
import 'package:anotacoes/ui/widget/anotation_widget.dart';
import 'package:anotacoes/utils/Translations.dart';
import 'package:anotacoes/utils/constants.dart';
import 'package:anotacoes/utils/utils.dart';
import 'package:anotacoes/viewmodel/anotation_model.dart';
import 'package:avatar_letter/avatar_letter.dart';
import 'package:flutter/material.dart';

import 'base_view.dart';

class SearchPage extends StatefulWidget {
  const SearchPage();

  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  SearchView _searchView;

  TextEditingController _searchQuery;
  bool _isSearching = false;
  String searchQuery = "Search query";

  @override
  void initState() {
    _searchView = SearchView();
    super.initState();
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
        hintStyle:   TextStyle(color: colorParse(hexCode:COLOR_DEFAULT).withOpacity(0.5)),
      ),
      style: TextStyle(color: colorParse(hexCode:COLOR_DEFAULT), fontSize: 16.0),
      onChanged: updateSearchQuery,
    );
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      _searchView.autoSearch(newQuery);
      searchQuery = newQuery;
    });
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
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        leading: _isSearching ? const BackButton() : null,
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        actions: _buildActions(),
      ),
      body: new Center(
        child: _searchView,
      ),
    );
  }
}

class SearchView extends StatelessWidget {
  AnotationModel _searchModel;
  String valueSearch = '';

  _build(AnotationModel model) {
//    _searchModel = model;
    switch (model.state) {
      case ViewState.Busy:
        return Center(
          child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(colorParse(hexCode:COLOR_DEFAULT)),
          ),
        );
      case ViewState.Idle:
        return Container(
            margin: EdgeInsets.only(top: 8.0),
            child: ListView.builder(
                itemCount: model.anotations.length,
                itemBuilder: (context, index) {
                  var anotation = model.anotations[index];
                  return ASearchItem(
                    key: Key('${anotation.title}'),
                    anotation: anotation,
                    onTap: () {
                      Navigator.pushNamed(
                          _searchModel.context(), '/newAnotation',
                          arguments: _searchModel.anotations[index]);
                    },
                  );
                }));
      case ViewState.Refresh:
      case ViewState.Empty:
        return Center(
          child: Text('${Translations.current.text('no_notes_found')} {${valueSearch}}'),
        );
    }
  }

  void autoSearch(String value) {
    valueSearch = value;
    if(value.isEmpty)
      return;
    _searchModel.search(value);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AnotationModel>(onModelReady: (model) {
      model.initSearch(context);
      _searchModel = model;
    }, builder: (context, model, child) {
      return Scaffold(
        body: SafeArea(
            child: Container(
          child: _build(model),
        )),
      );
    });
  }
}
