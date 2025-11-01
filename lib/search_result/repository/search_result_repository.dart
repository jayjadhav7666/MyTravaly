import 'dart:async';
import 'dart:io';
import 'package:my_travely/constants/api_constants.dart';
import 'package:my_travely/search_result/model/search_result_model.dart';
import 'package:my_travely/utils/shared_preference_helper.dart';
import 'package:my_travely/utils/api_request.dart';
import 'package:my_travely/utils/common_api_result_model.dart';

class SearchResultCompleteRepository {
  Future<ApiResult<SearchResultModel>> fetchSearchResultsData({
    required String checkInDate,
    required String checkOutDate,
    required int rooms,
    required int adults,
    required int children,
    required String searchType,
    required String searchQuery,
    int limit = 5,
    int offset = 0,
  }) async {
    final String visitorToken =
        await SharedPreferenceHelper.instance.getVisitorToken();
    final Map<String, String> headers = {
      "authtoken": ApiConstants.authToken,
      "visitortoken": visitorToken,
      "Content-Type": "application/json"
    };

    final Map<String, dynamic> requestBody = {
      "action": "getSearchResultListOfHotels",
      "getSearchResultListOfHotels": {
        "searchCriteria": {
          "checkIn": checkInDate,
          "checkOut": checkOutDate,
          "rooms": rooms,
          "adults": adults,
          "children": 0,
          "searchType": searchType,
          "searchQuery": [searchQuery],
          "accommodation": [
            "all",
            "hotel" //allowed "hotel","resort","Boat House","bedAndBreakfast","guestHouse","Holidayhome","cottage","apartment","Home Stay", "hostel","Guest House","Camp_sites/tent","co_living","Villa","Motel","Capsule Hotel","Dome Hotel","all"
          ],
          "arrayOfExcludedSearchType": [
            "street" //allowed street, city, state, country
          ],
          "highPrice": "3000000",
          "lowPrice": "0",
          "limit": limit,
          "preloaderList": [],
          "currency": "INR",
          "rid": offset
        }
      }
    };

    try {
      final response = await ApiRequest().sendPostRequest(
        url: ApiConstants.baseUrl,
        body: requestBody,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonString = ApiRequest().returnResponse(response);

        final resultList = SearchResultModel.fromJson(jsonString);
        return ApiResult(data: resultList, statusCode: response.statusCode);
      } else if (response.statusCode == 400) {
        return ApiResult(
          errorMessage: "Bad request. Please check your input and try again.",
          statusCode: response.statusCode,
        );
      } else if (response.statusCode == 401) {
        return ApiResult(
          errorMessage: "Unauthorized access. Please log in again.",
          statusCode: response.statusCode,
        );
      } else {
        return ApiResult(
          errorMessage:
              "Unexpected error occurred. Status code: ${response.statusCode}",
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      return ApiResult(
        errorMessage:
            "No internet connection. Please check your network and try again.",
        statusCode: 0,
      );
    } on TimeoutException {
      return ApiResult(
        errorMessage: "The request has timed out. Please try again later.",
        statusCode: 0,
      );
    } on FormatException {
      return ApiResult(
        errorMessage: "Invalid response format. Please contact support.",
        statusCode: 0,
      );
    } catch (e) {
      return ApiResult(
        errorMessage: "An unexpected error occurred: ${e.toString()}",
        statusCode: 0,
      );
    }
  }
}
