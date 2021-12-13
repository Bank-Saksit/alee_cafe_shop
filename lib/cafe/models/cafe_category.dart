import 'package:equatable/equatable.dart';

class CafeCategoryModel extends Equatable {
  final int categoryId;
  final String categoryName;

  CafeCategoryModel({this.categoryId, this.categoryName});
  @override
  List<Object> get props => [this.categoryId, this.categoryName];

}