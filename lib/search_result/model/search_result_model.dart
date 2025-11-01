class SearchResultModel {
  SearchResultModel({
    required this.status,
    required this.message,
    required this.responseCode,
    required this.data,
  });

  final bool? status;
  final String? message;
  final int? responseCode;
  final SearchResultModelData? data;

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      status: json["status"],
      message: json["message"],
      responseCode: json["responseCode"],
      data: json["data"] == null
          ? null
          : SearchResultModelData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "responseCode": responseCode,
        "data": data?.toJson(),
      };
}

class SearchResultModelData {
  SearchResultModelData({
    required this.arrayOfHotelList,
    required this.arrayOfExcludedHotels,
    required this.arrayOfExcludedSearchType,
  });

  late final List<ArrayOfHotelList> arrayOfHotelList;
  final List<String> arrayOfExcludedHotels;
  final List<String> arrayOfExcludedSearchType;

  factory SearchResultModelData.fromJson(Map<String, dynamic> json) {
    return SearchResultModelData(
      arrayOfHotelList: json["arrayOfHotelList"] == null
          ? []
          : List<ArrayOfHotelList>.from(json["arrayOfHotelList"]!
              .map((x) => ArrayOfHotelList.fromJson(x))),
      arrayOfExcludedHotels: json["arrayOfExcludedHotels"] == null
          ? []
          : List<String>.from(json["arrayOfExcludedHotels"]!.map((x) => x)),
      arrayOfExcludedSearchType: json["arrayOfExcludedSearchType"] == null
          ? []
          : List<String>.from(json["arrayOfExcludedSearchType"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "arrayOfHotelList": arrayOfHotelList.map((x) => x.toJson()).toList(),
        "arrayOfExcludedHotels": arrayOfExcludedHotels.map((x) => x).toList(),
        "arrayOfExcludedSearchType":
            arrayOfExcludedSearchType.map((x) => x).toList(),
      };
}

class ArrayOfHotelList {
  ArrayOfHotelList({
    required this.propertyCode,
    required this.propertyName,
    required this.propertyImage,
    required this.propertytype,
    required this.propertyStar,
    required this.propertyPoliciesAndAmmenities,
    required this.propertyAddress,
    required this.propertyUrl,
    required this.roomName,
    required this.numberOfAdults,
    required this.markedPrice,
    required this.propertyMaxPrice,
    required this.propertyMinPrice,
    required this.availableDeals,
    required this.subscriptionStatus,
    required this.propertyView,
    required this.isFavorite,
    required this.simplPriceList,
    required this.googleReview,
  });

  final String? propertyCode;
  final String? propertyName;
  final PropertyImage? propertyImage;
  final String? propertytype;
  final int? propertyStar;
  final PropertyPoliciesAndAmmenities? propertyPoliciesAndAmmenities;
  final PropertyAddress? propertyAddress;
  final String? propertyUrl;
  final String? roomName;
  final int? numberOfAdults;
  final Price? markedPrice;
  final Price? propertyMaxPrice;
  final Price? propertyMinPrice;
  final List<AvailableDeal> availableDeals;
  final SubscriptionStatus? subscriptionStatus;
  final int? propertyView;
  final bool? isFavorite;
  final SimplPriceList? simplPriceList;
  final GoogleReview? googleReview;

  factory ArrayOfHotelList.fromJson(Map<String, dynamic> json) {
    return ArrayOfHotelList(
      propertyCode: json["propertyCode"],
      propertyName: json["propertyName"],
      propertyImage: json["propertyImage"] == null
          ? null
          : PropertyImage.fromJson(json["propertyImage"]),
      propertytype: json["propertytype"],
      propertyStar: json["propertyStar"],
      propertyPoliciesAndAmmenities:
          json["propertyPoliciesAndAmmenities"] == null
              ? null
              : PropertyPoliciesAndAmmenities.fromJson(
                  json["propertyPoliciesAndAmmenities"]),
      propertyAddress: json["propertyAddress"] == null
          ? null
          : PropertyAddress.fromJson(json["propertyAddress"]),
      propertyUrl: json["propertyUrl"],
      roomName: json["roomName"],
      numberOfAdults: json["numberOfAdults"],
      markedPrice: json["markedPrice"] == null
          ? null
          : Price.fromJson(json["markedPrice"]),
      propertyMaxPrice: json["propertyMaxPrice"] == null
          ? null
          : Price.fromJson(json["propertyMaxPrice"]),
      propertyMinPrice: json["propertyMinPrice"] == null
          ? null
          : Price.fromJson(json["propertyMinPrice"]),
      availableDeals: json["availableDeals"] == null
          ? []
          : List<AvailableDeal>.from(
              json["availableDeals"]!.map((x) => AvailableDeal.fromJson(x))),
      subscriptionStatus: json["subscriptionStatus"] == null
          ? null
          : SubscriptionStatus.fromJson(json["subscriptionStatus"]),
      propertyView: json["propertyView"],
      isFavorite: json["isFavorite"],
      simplPriceList: json["simplPriceList"] == null
          ? null
          : SimplPriceList.fromJson(json["simplPriceList"]),
      googleReview: json["googleReview"] == null
          ? null
          : GoogleReview.fromJson(json["googleReview"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "propertyCode": propertyCode,
        "propertyName": propertyName,
        "propertyImage": propertyImage?.toJson(),
        "propertytype": propertytype,
        "propertyStar": propertyStar,
        "propertyPoliciesAndAmmenities":
            propertyPoliciesAndAmmenities?.toJson(),
        "propertyAddress": propertyAddress?.toJson(),
        "propertyUrl": propertyUrl,
        "roomName": roomName,
        "numberOfAdults": numberOfAdults,
        "markedPrice": markedPrice?.toJson(),
        "propertyMaxPrice": propertyMaxPrice?.toJson(),
        "propertyMinPrice": propertyMinPrice?.toJson(),
        "availableDeals": availableDeals.map((x) => x.toJson()).toList(),
        "subscriptionStatus": subscriptionStatus?.toJson(),
        "propertyView": propertyView,
        "isFavorite": isFavorite,
        "simplPriceList": simplPriceList?.toJson(),
        "googleReview": googleReview?.toJson(),
      };
}

class AvailableDeal {
  AvailableDeal({
    required this.headerName,
    required this.websiteUrl,
    required this.dealType,
    required this.price,
  });

  final String? headerName;
  final String? websiteUrl;
  final String? dealType;
  final Price? price;

  factory AvailableDeal.fromJson(Map<String, dynamic> json) {
    return AvailableDeal(
      headerName: json["headerName"],
      websiteUrl: json["websiteUrl"],
      dealType: json["dealType"],
      price: json["price"] == null ? null : Price.fromJson(json["price"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "headerName": headerName,
        "websiteUrl": websiteUrl,
        "dealType": dealType,
        "price": price?.toJson(),
      };
}

class Price {
  Price({
    required this.amount,
    required this.displayAmount,
    required this.currencyAmount,
    required this.currencySymbol,
  });

  final num? amount;
  final String? displayAmount;
  final String? currencyAmount;
  final String? currencySymbol;

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      amount: json["amount"],
      displayAmount: json["displayAmount"],
      currencyAmount: json["currencyAmount"],
      currencySymbol: json["currencySymbol"],
    );
  }

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "displayAmount": displayAmount,
        "currencyAmount": currencyAmount,
        "currencySymbol": currencySymbol,
      };
}

class GoogleReview {
  GoogleReview({
    required this.reviewPresent,
    required this.data,
  });

  final bool? reviewPresent;
  final GoogleReviewData? data;

  factory GoogleReview.fromJson(Map<String, dynamic> json) {
    return GoogleReview(
      reviewPresent: json["reviewPresent"],
      data:
          json["data"] == null ? null : GoogleReviewData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "reviewPresent": reviewPresent,
        "data": data?.toJson(),
      };
}

class GoogleReviewData {
  GoogleReviewData({
    required this.overallRating,
    required this.totalUserRating,
    required this.withoutDecimal,
  });

  final num? overallRating;
  final int? totalUserRating;
  final int? withoutDecimal;

  factory GoogleReviewData.fromJson(Map<String, dynamic> json) {
    return GoogleReviewData(
      overallRating: json["overallRating"],
      totalUserRating: json["totalUserRating"],
      withoutDecimal: json["withoutDecimal"],
    );
  }

  Map<String, dynamic> toJson() => {
        "overallRating": overallRating,
        "totalUserRating": totalUserRating,
        "withoutDecimal": withoutDecimal,
      };
}

class PropertyAddress {
  PropertyAddress({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.zipcode,
    required this.mapAddress,
    required this.latitude,
    required this.longitude,
  });

  final String? street;
  final String? city;
  final String? state;
  final String? country;
  final String? zipcode;
  final String? mapAddress;
  final num? latitude;
  final num? longitude;

  factory PropertyAddress.fromJson(Map<String, dynamic> json) {
    return PropertyAddress(
      street: json["street"],
      city: json["city"],
      state: json["state"],
      country: json["country"],
      zipcode: json["zipcode"],
      mapAddress: json["mapAddress"],
      latitude: json["latitude"],
      longitude: json["longitude"],
    );
  }

  Map<String, dynamic> toJson() => {
        "street": street,
        "city": city,
        "state": state,
        "country": country,
        "zipcode": zipcode,
        "mapAddress": mapAddress,
        "latitude": latitude,
        "longitude": longitude,
      };
}

class PropertyImage {
  PropertyImage({
    required this.fullUrl,
    required this.location,
    required this.imageName,
  });

  final String? fullUrl;
  final String? location;
  final String? imageName;

  factory PropertyImage.fromJson(Map<String, dynamic> json) {
    return PropertyImage(
      fullUrl: json["fullUrl"],
      location: json["location"],
      imageName: json["imageName"],
    );
  }

  Map<String, dynamic> toJson() => {
        "fullUrl": fullUrl,
        "location": location,
        "imageName": imageName,
      };
}

class PropertyPoliciesAndAmmenities {
  PropertyPoliciesAndAmmenities({
    required this.present,
    required this.data,
  });

  final bool? present;
  final PropertyPoliciesAndAmmenitiesData? data;

  factory PropertyPoliciesAndAmmenities.fromJson(Map<String, dynamic> json) {
    return PropertyPoliciesAndAmmenities(
      present: json["present"],
      data: json["data"] == null
          ? null
          : PropertyPoliciesAndAmmenitiesData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "present": present,
        "data": data?.toJson(),
      };
}

class PropertyPoliciesAndAmmenitiesData {
  PropertyPoliciesAndAmmenitiesData({
    required this.cancelPolicy,
    required this.refundPolicy,
    required this.childPolicy,
    required this.damagePolicy,
    required this.propertyRestriction,
    required this.petsAllowed,
    required this.coupleFriendly,
    required this.suitableForChildren,
    required this.bachularsAllowed,
    required this.freeWifi,
    required this.freeCancellation,
    required this.payAtHotel,
    required this.payNow,
    required this.lastUpdatedOn,
  });

  final String? cancelPolicy;
  final String? refundPolicy;
  final String? childPolicy;
  final String? damagePolicy;
  final String? propertyRestriction;
  final bool? petsAllowed;
  final bool? coupleFriendly;
  final bool? suitableForChildren;
  final bool? bachularsAllowed;
  final bool? freeWifi;
  final bool? freeCancellation;
  final bool? payAtHotel;
  final bool? payNow;
  final DateTime? lastUpdatedOn;

  factory PropertyPoliciesAndAmmenitiesData.fromJson(
      Map<String, dynamic> json) {
    return PropertyPoliciesAndAmmenitiesData(
      cancelPolicy: json["cancelPolicy"],
      refundPolicy: json["refundPolicy"],
      childPolicy: json["childPolicy"],
      damagePolicy: json["damagePolicy"],
      propertyRestriction: json["propertyRestriction"],
      petsAllowed: json["petsAllowed"],
      coupleFriendly: json["coupleFriendly"],
      suitableForChildren: json["suitableForChildren"],
      bachularsAllowed: json["bachularsAllowed"],
      freeWifi: json["freeWifi"],
      freeCancellation: json["freeCancellation"],
      payAtHotel: json["payAtHotel"],
      payNow: json["payNow"],
      lastUpdatedOn: DateTime.tryParse(json["lastUpdatedOn"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "cancelPolicy": cancelPolicy,
        "refundPolicy": refundPolicy,
        "childPolicy": childPolicy,
        "damagePolicy": damagePolicy,
        "propertyRestriction": propertyRestriction,
        "petsAllowed": petsAllowed,
        "coupleFriendly": coupleFriendly,
        "suitableForChildren": suitableForChildren,
        "bachularsAllowed": bachularsAllowed,
        "freeWifi": freeWifi,
        "freeCancellation": freeCancellation,
        "payAtHotel": payAtHotel,
        "payNow": payNow,
        "lastUpdatedOn": lastUpdatedOn?.toIso8601String(),
      };
}

class SimplPriceList {
  SimplPriceList({
    required this.simplPrice,
    required this.originalPrice,
  });

  final Price? simplPrice;
  final int? originalPrice;

  factory SimplPriceList.fromJson(Map<String, dynamic> json) {
    return SimplPriceList(
      simplPrice: json["simplPrice"] == null
          ? null
          : Price.fromJson(json["simplPrice"]),
      originalPrice: json["originalPrice"],
    );
  }

  Map<String, dynamic> toJson() => {
        "simplPrice": simplPrice?.toJson(),
        "originalPrice": originalPrice,
      };
}

class SubscriptionStatus {
  SubscriptionStatus({
    required this.status,
  });

  final bool? status;

  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) {
    return SubscriptionStatus(
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}
