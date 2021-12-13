import 'package:cafe_app/cafe/models/cafe_category.dart';

class CafeCategoryViewmodel {
  List<CafeCategoryModel> getCafeCategory() {
    return [
      CafeCategoryModel(
        categoryId : 1,
        categoryName: "คาเฟ่มินิมอล"
      ),
      CafeCategoryModel(
          categoryId : 2,
          categoryName: "คาเฟ่วิลเทจ"
      ),
      CafeCategoryModel(
          categoryId : 3,
          categoryName: "คาเฟ่ดอกไม้"
      ),
      CafeCategoryModel(
          categoryId : 4,
          categoryName: "คาเฟ่นั่งทำงาน"
      ),
    ];
  }
}