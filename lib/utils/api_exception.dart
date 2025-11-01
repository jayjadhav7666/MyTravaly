
import 'package:flutter/material.dart';

class ApiException implements Exception {
  final String? message;
  final String? _prefix;
  ApiException([this.message, this._prefix]);

  @override
  String toString() {
    return '$message$_prefix';
  }

  // Method to get user-friendly message
  String getUserFriendlyMessage() {
    return message ?? "An unknown error occurred.";
  }

  // Show error message to user using a Snackbar (or can be replaced with a Dialog, etc.)
  void showErrorMessage(BuildContext context) {
    final snackBar = SnackBar(content: Text(getUserFriendlyMessage()));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class FetchDataException extends ApiException {
  FetchDataException([String? message])
      : super(message ?? 'Error with Connection. Please check your internet and try again.', 'Error with Connection');

  @override
  String getUserFriendlyMessage() {
    return "Unable to connect. Please check your internet connection and try again.";
  }
}

class BadRequestException extends ApiException {
  BadRequestException([String? message])
      : super(message ?? 'Bad Request. Please try again.', 'Bad Request');

  @override
  String getUserFriendlyMessage() {
    return "There was a problem with the request. Please try again.";
  }
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([String? message])
      : super(message ?? 'Unauthorized Request. Please log in again.', 'Unauthorized Request');

  @override
  String getUserFriendlyMessage() {
    return "Your session has expired. Please log in again.";
  }
}

class InvalidException extends ApiException {
  InvalidException([String? message])
      : super(message ?? 'Invalid Request. Please check your inputs and try again.', 'Invalid Request');

  @override
  String getUserFriendlyMessage() {
    return "The request was invalid. Please check your inputs and try again.";
  }
}
