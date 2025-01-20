import 'dart:typed_data';

class SignatureModel {
  int? id;
  Uint8List? pngBytes;

  SignatureModel ({this.id, this.pngBytes});

  SignatureModel .fromMap(Map<String, dynamic> img)
      : id = img['id'],
        pngBytes = img['pngBytes'];

  Map<String, Object?> toMap() {
    return {'id': id, 'pngBytes': pngBytes};
  }
}
