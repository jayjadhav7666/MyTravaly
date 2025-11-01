class SearchAuto {
    SearchAuto({
        required this.status,
        required this.message,
        required this.responseCode,
        required this.data,
    });

    final bool? status;
    final String? message;
    final int? responseCode;
    final SearchAutoDataList? data;

    factory SearchAuto.fromJson(Map<String, dynamic> json){ 
        return SearchAuto(
            status: json["status"],
            message: json["message"],
            responseCode: json["responseCode"],
            data: json["data"] == null ? null : SearchAutoDataList.fromJson(json["data"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "responseCode": responseCode,
        "data": data?.toJson(),
    };

}

class SearchAutoDataList {
   SearchAutoDataList({
        required this.present,
        required this.totalNumberOfResult,
        required this.autoCompleteList,
    });

    final bool? present;
    final int? totalNumberOfResult;
    final AutoCompleteList? autoCompleteList;

    factory SearchAutoDataList.fromJson(Map<String, dynamic> json){ 
        return SearchAutoDataList(
            present: json["present"],
            totalNumberOfResult: json["totalNumberOfResult"],
            autoCompleteList: json["autoCompleteList"] == null ? null : AutoCompleteList.fromJson(json["autoCompleteList"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "present": present,
        "totalNumberOfResult": totalNumberOfResult,
        "autoCompleteList": autoCompleteList?.toJson(),
    };

}

class AutoCompleteList {
    AutoCompleteList({
        required this.byPropertyName,
        required this.byStreet,
        required this.byCity,
        required this.byState,
        required this.byCountry,
    });

    final By? byPropertyName;
    final By? byStreet;
    final By? byCity;
    final By? byState;
    final By? byCountry;

    factory AutoCompleteList.fromJson(Map<String, dynamic> json){ 
        return AutoCompleteList(
            byPropertyName: json["byPropertyName"] == null ? null : By.fromJson(json["byPropertyName"]),
            byStreet: json["byStreet"] == null ? null : By.fromJson(json["byStreet"]),
            byCity: json["byCity"] == null ? null : By.fromJson(json["byCity"]),
            byState: json["byState"] == null ? null : By.fromJson(json["byState"]),
            byCountry: json["byCountry"] == null ? null : By.fromJson(json["byCountry"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "byPropertyName": byPropertyName?.toJson(),
        "byStreet": byStreet?.toJson(),
        "byCity": byCity?.toJson(),
        "byState": byState?.toJson(),
        "byCountry": byCountry?.toJson(),
    };

}

class By {
    By({
        required this.present,
        required this.listOfResult,
        required this.numberOfResult,
    });

    final bool? present;
    final List<ListOfResult> listOfResult;
    final int? numberOfResult;

    factory By.fromJson(Map<String, dynamic> json){ 
        return By(
            present: json["present"],
            listOfResult: json["listOfResult"] == null ? [] : List<ListOfResult>.from(json["listOfResult"]!.map((x) => ListOfResult.fromJson(x))),
            numberOfResult: json["numberOfResult"],
        );
    }

    Map<String, dynamic> toJson() => {
        "present": present,
        "listOfResult": listOfResult.map((x) => x.toJson()).toList(),
        "numberOfResult": numberOfResult,
    };

}

class ListOfResult {
    ListOfResult({
        required this.valueToDisplay,
        required this.address,
        required this.searchArray,
        required this.propertyName,
    });

    final String? valueToDisplay;
    final Address? address;
    final SearchArray? searchArray;
    final String? propertyName;

    factory ListOfResult.fromJson(Map<String, dynamic> json){ 
        return ListOfResult(
            valueToDisplay: json["valueToDisplay"],
            address: json["address"] == null ? null : Address.fromJson(json["address"]),
            searchArray: json["searchArray"] == null ? null : SearchArray.fromJson(json["searchArray"]),
            propertyName: json["propertyName"],
        );
    }

    Map<String, dynamic> toJson() => {
        "valueToDisplay": valueToDisplay,
        "address": address?.toJson(),
        "searchArray": searchArray?.toJson(),
        "propertyName": propertyName,
    };

}

class Address {
    Address({
        required this.country,
        required this.city,
        required this.state,
        required this.street,
    });

    final String? country;
    final String? city;
    final String? state;
    final String? street;

    factory Address.fromJson(Map<String, dynamic> json){ 
        return Address(
            country: json["country"],
            city: json["city"],
            state: json["state"],
            street: json["street"],
        );
    }

    Map<String, dynamic> toJson() => {
        "country": country,
        "city": city,
        "state": state,
        "street": street,
    };

}

class SearchArray {
    SearchArray({
        required this.type,
        required this.query,
    });

    final String? type;
    final List<String> query;

    factory SearchArray.fromJson(Map<String, dynamic> json){ 
        return SearchArray(
            type: json["type"],
            query: json["query"] == null ? [] : List<String>.from(json["query"]!.map((x) => x)),
        );
    }

    Map<String, dynamic> toJson() => {
        "type": type,
        "query": query.map((x) => x).toList(),
    };

}
