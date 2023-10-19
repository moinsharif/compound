import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/core/base/base_service.dart';

import '_generic_firestore_repository_mobile.dart';

class GenericFirestoreService<T> extends BaseService {
  final String path;
  final T Function(Map<String, dynamic> data) fromJson;

  GenericFirestoreRepository repository;

  GenericFirestoreService._internal(this.path, this.fromJson) {
    this.repository = GenericFirestoreRepository(this.path);
  }

  factory GenericFirestoreService(
      String path, T Function(Map<String, dynamic> data) fromJson) {
    return GenericFirestoreService._internal(path, fromJson);
  }

  static Firestore get db {
    return Firestore.instance;
  }

  CollectionReference get ref {
    return this.repository.ref;
  }

  Future<List<T>> list() async {
    var list = await this.repository.list();
    return list.map((e) => this.fromJson(e)).toList();
  }

  Future<List<T>> getAll() async {
    var list = await this.repository.getAll();
    return list.map((e) => this.fromJson(e)).toList();
  }

  Stream<List<T>> stream() {
    return this.repository.stream().map((list) => list.map((e) => fromJson(e)));
  }

  Future<T> getById(String id) async {
    var object = await this.repository.getById(id);
    return object != null ? this.fromJson(object) : null;
  }

  Future<T> getByInnerId(String id) async {
    var object = await this.repository.getByInnerId(id);
    return object != null ? this.fromJson(object) : null;
  }

  Future<String> add(T data) async {
    var id = await this.repository.add(data);
    return id;
  }

  Future setData(T data, String id, {bool merge = false}) async {
    await this.repository.setData(data, id, merge: merge);
  }

  Future update(T data, String id) async {
    await this.repository.update(data, id);
  }

  Future delete(String id) async {
    await this.repository.delete(id);
  }
}
