import '/flutter_flow/flutter_flow_util.dart';
import 'home_seller_profile_reviews_step2_widget.dart'
    show HomeSellerProfileReviewsStep2Widget;
import 'package:flutter/material.dart';

class HomeSellerProfileReviewsStep2Model
    extends FlutterFlowModel<HomeSellerProfileReviewsStep2Widget> {
  ///  Local state fields for this page.

  List<FFUploadedFile> images = [];
  void addToImages(FFUploadedFile item) => images.add(item);
  void removeFromImages(FFUploadedFile item) => images.remove(item);
  void removeAtIndexFromImages(int index) => images.removeAt(index);
  void insertAtIndexInImages(int index, FFUploadedFile item) =>
      images.insert(index, item);
  void updateImagesAtIndex(int index, Function(FFUploadedFile) updateFn) =>
      images[index] = updateFn(images[index]);

  ///  State fields for stateful widgets in this page.

  // State field(s) for RatingBar widget.
  double? ratingBarValue2;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  bool isDataUploading_uploadDataFz3 = false;
  FFUploadedFile uploadedLocalFile_uploadDataFz3 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // Stores action output result for [Custom Action - uploadReviewImages] action in Button widget.
  List<String>? uploadReviewImages;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
