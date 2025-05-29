import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../core/common/failure.dart';
import '../../data/models/product_form_model.dart';
import '../repositories/product_repository.dart';

class AddProduct {
  final ProductRepository repository;

  AddProduct(this.repository);

  Future<Either<Failure, void>> execute(
    ProductFormModel formModel,
    File imageFile,
  ) {
    return repository.addProduct(formModel, imageFile);
  }
}
