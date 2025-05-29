import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../core/common/failure.dart';
import '../../data/models/product_form_model.dart';
import '../repositories/product_repository.dart';

class UpdateProduct {
  final ProductRepository repository;

  UpdateProduct(this.repository);

  Future<Either<Failure, void>> execute(
    String id,
    ProductFormModel formModel,
    File? imageFile,
  ) {
    return repository.updateProduct(id, formModel, imageFile);
  }
}
