import 'package:equatable/equatable.dart';

class CafeInfoModel extends Equatable {
  String id;
  final String cafeName;
  final String cafeDescription;
  final String cafeAddress;
  final String cafeTimeDescription;
  final String cafePhoneNumber;
  String cafePathImage;
  final String cafeCategory;

  CafeInfoModel(
      {
        this.id,
      this.cafeName,
      this.cafeDescription,
      this.cafeAddress,
      this.cafeTimeDescription,
      this.cafePhoneNumber,
      this.cafePathImage,
      this.cafeCategory});

  List<Object> get props => [
        id,
        cafeName,
        cafeDescription,
        cafeAddress,
        cafeTimeDescription,
        cafePhoneNumber,
        cafePathImage,
        cafeCategory
      ];

  CafeInfoModel.fromSnapshot(var value)
      : cafeName = value["cafeName"],
        cafeDescription = value["cafeDescription"],
        cafeAddress = value["cafeAddress"],
        cafeTimeDescription = value["cafeTimeDescription"],
        cafePhoneNumber = value["cafePhoneNumber"],
        cafePathImage = value["cafePathImage"],
        cafeCategory = value["cafeCategory"];

  toJson() {
    return {
      "cafeName": cafeName,
      "cafeDescription": cafeDescription,
      "cafeAddress": cafeAddress,
      "cafeTimeDescription": cafeTimeDescription,
      "cafePhoneNumber": cafePhoneNumber,
      "cafePathImage": cafePathImage,
      "cafeCategory": cafeCategory,
    };
  }
}
