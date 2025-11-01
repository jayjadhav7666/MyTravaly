// import 'dart:convert';
// import 'package:my_travely/constants/api_constants.dart';
// import 'package:http/http.dart' as http;
// import 'package:my_travely/homePage/model/hotels_model.dart';

// class ApiServices {
//   String? visitorToken;
//   Future<void> registerDevice() async {
//     Uri url = Uri.parse(ApiConstants.baseUrl);

//     final body = {
//       "action": "deviceRegister",
//       "deviceRegister": {
//         "deviceModel": "RMX3521",
//         "deviceFingerprint":
//             "realme/RMX3521/RE54E2L1:13/RKQ1.211119.001/S.f1bb32-7f7fa_1:user/release-keys",
//         "deviceBrand": "realme",
//         "deviceId": "RE54E2L1",
//         "deviceName": "RMX3521_11_C.10",
//         "deviceManufacturer": "realme",
//         "deviceProduct": "RMX3521",
//         "deviceSerialNumber": "unknown"
//       }
//     };
//     http.Response response = await http.post(
//       url,
//       headers: {
//         "authtoken": ApiConstants.authToken,
//         "Content-Type": "application/json",
//       },
//       body: jsonEncode(body),
//     );

//     if (response.statusCode == 201) {
//       final info = jsonDecode(response.body);
//       visitorToken = info['data']['visitorToken'];
//     } else {
//       throw Exception("Device registration failed");
//     }
//   }

//   Future<List<Datum>> getPopularHotels({
//     required String country,
//     required String state,
//     required String city,
//   }) async {
//     visitorToken ??= await _getVisitor();
//     // final body = {
//     //   "action": "popularStay",
//     //   "popularStay": {
//     //     "limit": 10,
//     //     "entityType": "Any",
//     //     "filter": {
//     //       "searchType": "byCity",
//     //       "searchTypeInfo": {"country": country, "state": state, "city": city}
//     //     },
//     //     "currency": "INR"
//     //   }
//     // };
//     final body = {
//       "action": "popularStay",
//       "popularStay": {
//         "limit": 10, //maximum 10
//         "entityType": "Any", //hotel, resort, Home Stay, Camp_sites/tent, Any
//         "filter": {
//           "searchType": "byCity", //byCity, byState, byCountry, byRandom,
//           "searchTypeInfo": {
//             "country": "India",
//             "state": "Maharastra",
//             "city": "Pune Division"
//           }
//         },
//         "currency": "INR"
//       }
//     };
//     final res = await http.post(Uri.parse(ApiConstants.baseUrl),
//         headers: {
//           "authtoken": ApiConstants.authToken,
//           "visitortoken": visitorToken!,
//           "Content-Type": "application/json"
//         },
//         body: jsonEncode(body));

//     if (res.statusCode == 200) {
//       final data = Hotels.fromJson(jsonDecode(res.body));
//       return data.data;
//     } else {
//       throw Exception("Failed to fetch hotels");
//     }
//   }

//   // Future<List<dynamic>> searchHotels({
//   //   required List<String> hotelIds,
//   //   required String checkIn,
//   //   required String checkOut,
//   // }) async {
//   //   visitorToken ??= await _getVisitor();

//   //   final body = {
//   //     "action": "getSearchResultListOfHotels",
//   //     "getSearchResultListOfHotels": {
//   //       "searchCriteria": {
//   //         "checkIn": checkIn,
//   //         "checkOut": checkOut,
//   //         "rooms": 2,
//   //         "adults": 2,
//   //         "children": 0,
//   //         "searchType": "hotelIdSearch",
//   //         "searchQuery": hotelIds,
//   //         "accommodation": ["all", "hotel"],
//   //         "arrayOfExcludedSearchType": ["street"],
//   //         "highPrice": "3000000",
//   //         "lowPrice": "0",
//   //         "limit": 5,
//   //         "preloaderList": [],
//   //         "currency": "INR",
//   //         "rid": 0
//   //       }
//   //     }
//   //   };

//   //   final res = await http.post(Uri.parse(baseUrl),
//   //       headers: {
//   //         "authtoken": authToken,
//   //         "visitortoken": visitorToken!,
//   //         "Content-Type": "application/json"
//   //       },
//   //       body: jsonEncode(body));

//   //   if (res.statusCode == 200) {
//   //     final data = jsonDecode(res.body);
//   //     return data["getSearchResultListOfHotels"] ?? [];
//   //   } else {
//   //     throw Exception("Failed to search hotels");
//   //   }
//   // }

//   Future<String> _getVisitor() async {
//     await registerDevice();
//     return visitorToken!;
//   }
// }
