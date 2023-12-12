abstract class Status {
  static const int httpContinue_ = 100;
  static const int httpSwitchingProtocols = 101;

  static const int httpProcessing = 102;
  static const int httpOk = 200;
  static const int httpCreated = 201;
  static const int httpAccepted = 202;
  static const int httpNonAuthoritativeInformation = 203;
  static const int httpNoContent = 204;
  static const int httpResetContent = 205;
  static const int httpPartialContent = 206;

  static const int httpMultiStatus = 207;

  static const int httpAlreadyReported = 208;

  static const int httpImUsed = 226;
  static const int httpMultipleChoices = 300;
  static const int httpMovedPermanently = 301;
  static const int httpFound = 302;
  static const int httpMovedTemporarily = 302; // Common alias for found.
  static const int httpSeeOther = 303;
  static const int httpNotModified = 304;
  static const int httpUseProxy = 305;
  static const int httpTemporaryRedirect = 307;

  static const int httpPermanentRedirect = 308;
  static const int httpBadRequest = 400;
  static const int httpUnauthorized = 401;
  static const int httpPaymentRequired = 402;
  static const int httpForbidden = 403;
  static const int httpNotFound = 404;
  static const int httpMethodNotAllowed = 405;
  static const int httpNotAcceptable = 406;
  static const int httpProxyAuthenticationRequired = 407;
  static const int httpRequestTimeout = 408;
  static const int httpConflict = 409;
  static const int httpGone = 410;
  static const int httpLengthRequired = 411;
  static const int httpPreconditionFailed = 412;
  static const int httpRequestEntityTooLarge = 413;
  static const int httpRequestUriTooLong = 414;
  static const int httpUnsupportedMediaType = 415;
  static const int httpRequestedRangeNotSatisfiable = 416;
  static const int httpExpectationFailed = 417;

  static const int httpMisdirectedRequest = 421;

  static const int httpUnprocessableEntity = 422;

  static const int httpLocked = 423;

  static const int httpFailedDependency = 424;
  static const int httpUpgradeRequired = 426;

  static const int httpPreconditionRequired = 428;

  static const int httpTooManyRequests = 429;

  static const int httpRequestHeaderFieldsTooLarge = 431;

  static const int httpConnectionClosedWithoutResponse = 444;

  static const int httpUnavailableForLegalReasons = 451;

  static const int httpClientClosedRequest = 499;
  static const int httpInternalServerError = 500;
  static const int httpNotImplemented = 501;
  static const int httpBadGateway = 502;
  static const int httpServiceUnavailable = 503;
  static const int httpGatewayTimeout = 504;
  static const int httpVersionNotSupported = 505;

  static const int httpVariantAlsoNegotiates = 506;

  static const int httpInsufficientStorage = 507;

  static const int httpLoopDetected = 508;

  static const int httpNotExtended = 510;

  static const int httpNetworkAuthenticationRequired = 511;
  // Client generated status code.
  static const int httpNetworkConnectTimeoutError = 599;

  static const int submittedToOutbox = 600;

  @Deprecated("Use httpContinue_ instead")
  static const int CONTINUE = httpContinue_;
  @Deprecated("Use httpSwitchingProtocols instead")
  static const int SWITCHING_PROTOCOLS = httpSwitchingProtocols;
  @Deprecated("Use httpOk instead")
  static const int OK = httpOk;
  @Deprecated("Use httpCreated instead")
  static const int CREATED = httpCreated;
  @Deprecated("Use httpAccepted instead")
  static const int ACCEPTED = httpAccepted;
  @Deprecated("Use httpNonAuthoritativeInformation instead")
  static const int NON_AUTHORITATIVE_INFORMATION =
      httpNonAuthoritativeInformation;
  @Deprecated("Use httpNoContent instead")
  static const int NO_CONTENT = httpNoContent;
  @Deprecated("Use httpResetContent instead")
  static const int RESET_CONTENT = httpResetContent;
  @Deprecated("Use httpPartialContent instead")
  static const int PARTIAL_CONTENT = httpPartialContent;
  @Deprecated("Use httpMultipleChoices instead")
  static const int MULTIPLE_CHOICES = httpMultipleChoices;
  @Deprecated("Use httpMovedPermanently instead")
  static const int MOVED_PERMANENTLY = httpMovedPermanently;
  @Deprecated("Use httpFound instead")
  static const int FOUND = httpFound;
  @Deprecated("Use httpMovedTemporarily instead")
  static const int MOVED_TEMPORARILY = httpMovedTemporarily;
  @Deprecated("Use httpSeeOther instead")
  static const int SEE_OTHER = httpSeeOther;
  @Deprecated("Use httpNotModified instead")
  static const int NOT_MODIFIED = httpNotModified;
  @Deprecated("Use httpUseProxy instead")
  static const int USE_PROXY = httpUseProxy;
  @Deprecated("Use httpTemporaryRedirect instead")
  static const int TEMPORARY_REDIRECT = httpTemporaryRedirect;
  @Deprecated("Use httpBadRequest instead")
  static const int BAD_REQUEST = httpBadRequest;
  @Deprecated("Use httpUnauthorized instead")
  static const int UNAUTHORIZED = httpUnauthorized;
  @Deprecated("Use httpPaymentRequired instead")
  static const int PAYMENT_REQUIRED = httpPaymentRequired;
  @Deprecated("Use httpForbidden instead")
  static const int FORBIDDEN = httpForbidden;
  @Deprecated("Use httpNotFound instead")
  static const int NOT_FOUND = httpNotFound;
  @Deprecated("Use httpMethodNotAllowed instead")
  static const int METHOD_NOT_ALLOWED = httpMethodNotAllowed;
  @Deprecated("Use httpNotAcceptable instead")
  static const int NOT_ACCEPTABLE = httpNotAcceptable;
  @Deprecated("Use httpProxyAuthenticationRequired instead")
  static const int PROXY_AUTHENTICATION_REQUIRED =
      httpProxyAuthenticationRequired;
  @Deprecated("Use httpRequestTimeout instead")
  static const int REQUEST_TIMEOUT = httpRequestTimeout;
  @Deprecated("Use httpConflict instead")
  static const int CONFLICT = httpConflict;
  @Deprecated("Use httpGone instead")
  static const int GONE = httpGone;
  @Deprecated("Use httpLengthRequired instead")
  static const int LENGTH_REQUIRED = httpLengthRequired;
  @Deprecated("Use httpPreconditionFailed instead")
  static const int PRECONDITION_FAILED = httpPreconditionFailed;
  @Deprecated("Use httpRequestEntityTooLarge instead")
  static const int REQUEST_ENTITY_TOO_LARGE = httpRequestEntityTooLarge;
  @Deprecated("Use httpRequestUriTooLong instead")
  static const int REQUEST_URI_TOO_LONG = httpRequestUriTooLong;
  @Deprecated("Use httpUnsupportedMediaType instead")
  static const int UNSUPPORTED_MEDIA_TYPE = httpUnsupportedMediaType;
  @Deprecated("Use httpRequestedRangeNotSatisfiable instead")
  static const int REQUESTED_RANGE_NOT_SATISFIABLE =
      httpRequestedRangeNotSatisfiable;
  @Deprecated("Use httpExpectationFailed instead")
  static const int EXPECTATION_FAILED = httpExpectationFailed;
  @Deprecated("Use httpUpgradeRequired instead")
  static const int UPGRADE_REQUIRED = httpUpgradeRequired;
  @Deprecated("Use httpInternalServerError instead")
  static const int INTERNAL_SERVER_ERROR = httpInternalServerError;
  @Deprecated("Use httpNotImplemented instead")
  static const int NOT_IMPLEMENTED = httpNotImplemented;
  @Deprecated("Use httpBadGateway instead")
  static const int BAD_GATEWAY = httpBadGateway;
  @Deprecated("Use httpServiceUnavailable instead")
  static const int SERVICE_UNAVAILABLE = httpServiceUnavailable;
  @Deprecated("Use httpGatewayTimeout instead")
  static const int GATEWAY_TIMEOUT = httpGatewayTimeout;
  @Deprecated("Use httpVersionNotSupported instead")
  static const int HTTP_VERSION_NOT_SUPPORTED = httpVersionNotSupported;
  @Deprecated("Use httpNetworkConnectTimeoutError instead")
  static const int NETWORK_CONNECT_TIMEOUT_ERROR =
      httpNetworkConnectTimeoutError;
}
