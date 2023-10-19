import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/core/services/generic_firestore/generic_firestore.dart';
import 'package:compound/utils/string_utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:async/async.dart';

typedef MapCallback = dynamic Function(Map<String, dynamic>, {String id});
typedef CollectionReferenceCallback = Set<CollectionReference> Function();

class SearchUtils{

    static Map<String, dynamic> applySearchTransformTarget(Map<String, dynamic> json){
        
      var fuzzyFilters = ["firstName", 
                          "lastName",
                          "weight",
                          "college",
                          "highSchoolClass",
                          "sport",
                          "primaryPosition",
                          "state",
                          "city",
                          "class",
                          "gpa",
                          "stars",
                          "color"];

        var transformed = _applySearchTransform(fuzzyFilters, json, false, false);

        return transformed;
    }

    static Map<String, dynamic> applySearchTransformProfile(Map<String, dynamic> json){
        
      var fuzzyFilters = ["firstName", 
                          "lastName",
                          "weight",
                          "college",
                          "highSchoolClass",
                          "sport",
                          "primaryPosition",
                          "state",
                          "city",
                          "class",
                          "gpa"];

        var transformed = _applySearchTransform(fuzzyFilters, json, true, true);
        json["lastActivity"] = DateTime.now().millisecondsSinceEpoch;
        return transformed;
    }

    static Map<String, dynamic> _applySearchTransform(List<String> fuzzyFilters, 
                                                      Map<String, dynamic> json, 
                                                      bool weightAsArray, 
                                                      bool heightAsCm){

      fuzzyFilters.forEach((element){

          if(json[element] != null){
              if(json[element].toString().trim() != ""){
                json[PaginatedQuery.searchPrefix + element] = json[element].toString().toLowerCase().trim();
              }
          }
      });

      if(heightAsCm){
        var inches = !StringUtils.isNullOrEmpty(json["inches"])? int.parse(json["inches"]) : 0;
        var feet = !StringUtils.isNullOrEmpty(json["feet"])? int.parse(json["feet"]) : 0;

        json[PaginatedQuery.searchPrefix +"height"] = (feet * 12 + inches) * 2.54;
      } else {

         var heightValue = "";
         if(!StringUtils.isNullOrEmpty(json["feet"]))
                 heightValue += json["feet"]+"'";
         if(!StringUtils.isNullOrEmpty(json["inches"]))
                 heightValue += json["inches"]+"''";

         json[PaginatedQuery.searchPrefix +"height"] = heightValue;
      }
      
      if(!StringUtils.isNullOrEmpty(json["weight"])){

          if(weightAsArray){
            var maxVal = int.parse(json["weight"]);
            if(maxVal > 0){
              var values = [];
              for(var i = 0; i <= maxVal; i++){
                  values.add(i);
              }
              json[PaginatedQuery.searchPrefix +"weight"] = values;
            }
          } else {
              json[PaginatedQuery.searchPrefix +"weight"] = int.parse(json["weight"]);
          }
      }
    
      return json;
    }
}


class QueryParam{
  
   final List<String> omitFuzzyFields;
   final String  field;
   final dynamic isEqualTo;
   final dynamic isLessThan;
   final dynamic isLessThanOrEqualTo; 
   final dynamic isGreaterThan; 
   final dynamic isGreaterThanOrEqualTo;
   final dynamic arrayContains;
   final List<dynamic> arrayContainsAny; 
   final List<dynamic> whereIn;
   final bool isNull;

   QueryParam(this.field, {
              this.isEqualTo, 
              this.isLessThan, 
              this.isLessThanOrEqualTo, 
              this.isGreaterThan, 
              this.isGreaterThanOrEqualTo,
              this.arrayContains, 
              this.arrayContainsAny, 
              this.whereIn, 
              this.isNull,
              this.omitFuzzyFields});
}

class GenericPage<T>{
   bool hasMoreData;
   List<T> collection;

   GenericPage({this.hasMoreData, this.collection});
}

class Page{
   bool hasMoreData;
   List<dynamic> collection;

   Page({this.hasMoreData, this.collection});
}

class PaginatedQuery{

  static String searchPrefix = "_search_";
  static String filterPrefix = "_search_filters";

  Subject $stream;

  String _searchField;
  String _searchValue;
  Iterable<String> _orderBy;

  int pageLimit = 5;
  List<List<dynamic>> _allPagedResults = List<List<dynamic>>();
  CollectionReference _collectionReference;

  CollectionReferenceCallback collectionRefSolver;

  List<QueryParam> _where;

  final String collectionRef;
  final MapCallback map;

  PaginatedQuery(this.collectionRef, this.map, {this.collectionRefSolver}){
      _collectionReference = this.collectionRefSolver != null? 
                          this.collectionRefSolver().first : 
                          GenericFirestoreService.db.collection(collectionRef);
  }

  DocumentSnapshot _lastDocument;
  bool _hasMoreData;

  Subject query(String searchField,
                String searchValue, 
                Iterable<String> orderBy,
                { limit ,
                  List<QueryParam> where }){

    if(limit != null)
       this.pageLimit = limit;

    this._searchField = searchField;
    this._searchValue = searchValue;
    this._orderBy = orderBy;
    this._lastDocument = null;
    this._allPagedResults.clear();
    this._hasMoreData = true;
    this._where = where;
    this.$stream = PublishSubject<Page>();
    fetchNextPage();
    return $stream;
  }

  void dispose(){
    this.$stream.close();
  }

  Query _applyWhere(Query query, bool isFuzzyActive){
    
    if(this._where == null || this._where.length < 1){
      return query;
    }

    var tempQuery = query == null? _collectionReference : query;
    for(var i = 0; i < this._where.length; i++){

        if(this._where[i].isEqualTo != null){
           tempQuery = tempQuery.where(searchPrefix + this._where[i].field, isEqualTo: this._where[i].isEqualTo.toLowerCase());
           continue;
        }
        if(this._where[i].isGreaterThanOrEqualTo != null){
           if(isFuzzyActive){
            tempQuery = tempQuery.where(searchPrefix + this._where[i].field, isEqualTo: this._where[i].isGreaterThanOrEqualTo);
             continue;
           }

           tempQuery = tempQuery
                          .where(searchPrefix + this._where[i].field, isGreaterThanOrEqualTo: this._where[i].isGreaterThanOrEqualTo)
                          .orderBy(searchPrefix + this._where[i].field);
           continue;
        }
        if(this._where[i].whereIn != null){
           tempQuery = tempQuery.where(searchPrefix + this._where[i].field, whereIn: this._where[i].whereIn);
           continue;
        }
        if(this._where[i].arrayContainsAny != null){
           tempQuery = tempQuery.where(searchPrefix + this._where[i].field, arrayContainsAny: this._where[i].arrayContainsAny);
           continue;
        }
         /*if(this._where[i].isLessThan != null){
           tempQuery = tempQuery.where(this._where[i].field, isLessThan: this._where[i].isLessThan);
           continue;
        }
        if(this._where[i].isLessThanOrEqualTo != null){
           tempQuery = tempQuery.where(this._where[i].field, isLessThanOrEqualTo: this._where[i].isLessThanOrEqualTo);
           continue;         
        }
        if(this._where[i].isGreaterThan != null){
           tempQuery = tempQuery.where(this._where[i].field, isGreaterThan: this._where[i].isGreaterThan);
           continue;
        } 
        if(this._where[i].arrayContains != null){
           tempQuery = tempQuery.where(this._where[i].field, arrayContains: this._where[i].arrayContains);
           continue;
        }
        if(this._where[i].arrayContainsAny != null){
           tempQuery = tempQuery.where(this._where[i].field, arrayContainsAny: this._where[i].arrayContainsAny);
           continue;
        }
        if(this._where[i].isNull != null){
           tempQuery = tempQuery.where(this._where[i].field, isNull: this._where[i].isNull);
        }*/
    }

    return tempQuery;
  }

  void fetchNextPage() async{

      Query query;
      var searchField = searchPrefix + _searchField;
      if(_searchValue == null || _searchValue == ""){
         query = _collectionReference;

         if(_where != null && _where.length > 0){
            query = _applyWhere(query, false);
         }

         query = query.where("searchable", isEqualTo: true);
         query = query.orderBy(this._orderBy.first, descending: true)
                        .limit(pageLimit);
      } else {
         var searchValue = _searchValue.toLowerCase();
         query = _collectionReference.where(searchField, isGreaterThanOrEqualTo: searchValue)
         .where(searchField, isLessThan: searchValue.substring(0, searchValue.length-1) 
                            + String.fromCharCode(searchValue.codeUnitAt(searchValue.length-1) + 1));

         if(_where != null && _where.length > 0){
            query = _applyWhere(query, true);
         }

         query = query.where("searchable", isEqualTo: true);
         query = query.limit(pageLimit)
                    .orderBy(searchField)
                    .orderBy(this._orderBy.first, descending: true);
      }

      if (_lastDocument != null){
         query = query.startAfterDocument(_lastDocument);
      }

      if (!_hasMoreData){
        $stream.add(Page(hasMoreData: _hasMoreData, collection:List<dynamic>()));
        return;
      }

      var currentRequestIndex = _allPagedResults.length;
      var snapshot = await query.getDocuments();

      if (snapshot.documents.isNotEmpty) {

        var toEmitDocuments = [];
        var documents = [];
        
        snapshot.documents
            .forEach((snapshot) {
                var data = snapshot.data;    
                var mapped =  map(data, id: snapshot.documentID);                
                toEmitDocuments.add(mapped);   
                documents.add(mapped);
            });


        var pageExists = currentRequestIndex < _allPagedResults.length;
        if (pageExists) {
          _allPagedResults[currentRequestIndex] = documents;
        } else {
          _allPagedResults.add(documents);       
        }
        
        if (currentRequestIndex == _allPagedResults.length - 1) {
          _lastDocument = snapshot.documents.last;
        }

        _hasMoreData = documents.length == pageLimit;
        $stream.add(Page(hasMoreData: _hasMoreData, collection:toEmitDocuments));
      } else {
        _hasMoreData = false;
        $stream.add(Page(hasMoreData: _hasMoreData, collection:List<dynamic>()));
        _allPagedResults.add(List<dynamic>());
      }
  }
}


class PaginatedMultiQuery{

    final String collectionRef;
    CollectionReferenceCallback collectionRefSolver;

    int _pageLimit = 5;
    Map<int, PaginatedQuery> queries;
    Map<String, dynamic> collection;
    StreamZip _streamZip;
    StreamSubscription _streamZipSuscription;
    StreamController<Page> pageStream$ = StreamController<Page>.broadcast();
    PaginatedMultiQuery(this.collectionRef, {this.collectionRefSolver});

    dispose(){
      if(pageStream$ != null)
          pageStream$.close();
      if(_streamZipSuscription != null)
          _streamZipSuscription.cancel();

      queries.values.forEach((query) {
        if(!query.$stream.isClosed)
          query.$stream.close();
      });
    }

    Stream fuzzySearch(String searchValue,
                      MapCallback map,
                      Iterable<String> searchFields,
                      Iterable<String> orderBy,
                      { List<QueryParam> where }){

        queries = Map<int, PaginatedQuery>();
        collection = Map<String, dynamic>();

        for(var i = 0; i < searchFields.length; i++){

            var searchField = searchFields.elementAt(i);
            if(where != null && where.length > 0){
              var omitField = false;
              for(var j = 0; j < where.length; j++){
                  if(where[j].omitFuzzyFields != null 
                      && where[j].omitFuzzyFields.length > 0
                      && where[j].omitFuzzyFields.contains(searchField)){
                     omitField = true;
                     break;
                  }
              }
              if(omitField)
                continue;
            }

            queries[i] = PaginatedQuery(collectionRef, map, collectionRefSolver: this.collectionRefSolver);
            queries[i].query(searchField, searchValue, orderBy, limit: _pageLimit, where: where);
            if(searchValue == null || searchValue == "")
              break;
        }

        _combiner();
        return pageStream$.stream;
    }

    fetchNextPage(){
      queries.values.forEach((query) {
          query.fetchNextPage();
      });
    }

    _combiner(){
      _streamZip = StreamZip(queries.values.map((item) => item.$stream));
      _streamZip.listen((List<dynamic> pages){
         var newPage = _addPage(pages);
         this.pageStream$.sink.add(newPage);
      });
    }

    Page _addPage(List<dynamic> pages){

          var newPage = List<dynamic>();
          var hasMoreData = false;
          for(var i = 0; i < pages.length; i++){

              var pageCollection = pages[i].collection;
              if(pages[i].hasMoreData)
                hasMoreData = true;

              for(var j = 0; j < pageCollection.length; j++)
              {
                 var document = pageCollection[j];
                 if(collection.containsKey(document.id)){
                    continue;
                 }

                 collection[document.id] = document;
                 newPage.add(document);
              }
          }

          return Page(hasMoreData: hasMoreData, collection: newPage);
    }
}