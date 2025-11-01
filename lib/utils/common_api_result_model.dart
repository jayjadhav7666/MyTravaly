/// This class is used as the common APi result container for each API call
class ApiResult<T> {
  final T? data;
  final String? errorMessage;
  final int statusCode;

  ApiResult({this.data, this.errorMessage,required this.statusCode});
}