/// Model class representing a Hotel
/// Contains all hotel information including location, rating, pricing, policies, and amenities
class HotelModel {
  final String id;
  final String name;
  final String? imageUrl;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? zipcode;
  final double? rating;
  final int? totalReviews;
  final double? price;
  final double? markedPrice;
  final String? priceDisplay;
  final int? stars;
  final String? propertyType;
  final String? propertyUrl;
  final double? latitude;
  final double? longitude;

  // Room and Guest Information
  final String? roomName;
  final int? numberOfAdults;

  // Property Policies and Amenities
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

  // Price Information
  final double? propertyMinPrice;
  final String? propertyMinPriceDisplay;
  final double? propertyMaxPrice;
  final String? propertyMaxPriceDisplay;
  final String? currencySymbol;

  // Deals
  final List<HotelDeal>? availableDeals;

  // Additional Status
  final bool? subscriptionStatus;
  final int? propertyView;
  final bool? isFavorite;

  // Simpl Price
  final double? simplPrice;
  final String? simplPriceDisplay;
  final double? originalPrice;

  HotelModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.address,
    this.city,
    this.state,
    this.country,
    this.zipcode,
    this.rating,
    this.totalReviews,
    this.price,
    this.markedPrice,
    this.priceDisplay,
    this.stars,
    this.propertyType,
    this.propertyUrl,
    this.latitude,
    this.longitude,
    this.roomName,
    this.numberOfAdults,
    this.cancelPolicy,
    this.refundPolicy,
    this.childPolicy,
    this.damagePolicy,
    this.propertyRestriction,
    this.petsAllowed,
    this.coupleFriendly,
    this.suitableForChildren,
    this.bachularsAllowed,
    this.freeWifi,
    this.freeCancellation,
    this.payAtHotel,
    this.payNow,
    this.propertyMinPrice,
    this.propertyMinPriceDisplay,
    this.propertyMaxPrice,
    this.propertyMaxPriceDisplay,
    this.currencySymbol,
    this.availableDeals,
    this.subscriptionStatus,
    this.propertyView,
    this.isFavorite,
    this.simplPrice,
    this.simplPriceDisplay,
    this.originalPrice,
  });

  /// Create HotelModel from JSON response
  factory HotelModel.fromJson(Map<String, dynamic> json) {
    final addressData = json['propertyAddress'] as Map<String, dynamic>?;
    final staticPriceData = json['staticPrice'] as Map<String, dynamic>?;
    final markedPriceData = json['markedPrice'] as Map<String, dynamic>?;
    final googleReviewData = json['googleReview'] as Map<String, dynamic>?;
    final reviewData = googleReviewData?['data'] as Map<String, dynamic>?;
    final policiesData = json['propertyPoliciesAndAmmenities'] as Map<String, dynamic>?;
    final policiesDetails = policiesData?['data'] as Map<String, dynamic>?;
    final minPriceData = json['propertyMinPrice'] as Map<String, dynamic>?;
    final maxPriceData = json['propertyMaxPrice'] as Map<String, dynamic>?;
    final subscriptionData = json['subscriptionStatus'] as Map<String, dynamic>?;
    final simplPriceListData = json['simplPriceList'] as Map<String, dynamic>?;
    final simplPriceData = simplPriceListData?['simplPrice'] as Map<String, dynamic>?;

    // Handle propertyImage - can be String or Object with fullUrl
    String? imageUrl;
    if (json['propertyImage'] != null) {
      if (json['propertyImage'] is String) {
        imageUrl = json['propertyImage'] as String;
      } else if (json['propertyImage'] is Map) {
        final imageData = json['propertyImage'] as Map<String, dynamic>;
        imageUrl = imageData['fullUrl']?.toString();
      }
    }

    // Parse available deals
    List<HotelDeal>? deals;
    if (json['availableDeals'] != null && json['availableDeals'] is List) {
      deals = (json['availableDeals'] as List)
          .map((deal) => HotelDeal.fromJson(deal as Map<String, dynamic>))
          .toList();
    }

    return HotelModel(
      id: json['propertyCode']?.toString() ?? '',
      name: json['propertyName']?.toString() ?? 'Unknown Hotel',
      imageUrl: imageUrl,
      address: addressData?['street']?.toString(),
      city: addressData?['city']?.toString(),
      state: addressData?['state']?.toString(),
      country: addressData?['country']?.toString(),
      zipcode: addressData?['zipcode']?.toString(),
      rating: reviewData?['overallRating'] != null
          ? double.tryParse(reviewData!['overallRating'].toString())
          : null,
      totalReviews: reviewData?['totalUserRating'] != null
          ? int.tryParse(reviewData!['totalUserRating'].toString())
          : null,
      price: staticPriceData?['amount'] != null
          ? double.tryParse(staticPriceData!['amount'].toString())
          : null,
      markedPrice: markedPriceData?['amount'] != null
          ? double.tryParse(markedPriceData!['amount'].toString())
          : null,
      priceDisplay: staticPriceData?['displayAmount']?.toString(),
      stars: json['propertyStar'] != null
          ? int.tryParse(json['propertyStar'].toString())
          : null,
      propertyType: json['propertytype']?.toString() ?? json['propertyType']?.toString(),
      propertyUrl: json['propertyUrl']?.toString(),
      latitude: addressData?['latitude'] != null
          ? double.tryParse(addressData!['latitude'].toString())
          : null,
      longitude: addressData?['longitude'] != null
          ? double.tryParse(addressData!['longitude'].toString())
          : null,
      roomName: json['roomName']?.toString(),
      numberOfAdults: json['numberOfAdults'] != null
          ? int.tryParse(json['numberOfAdults'].toString())
          : null,
      cancelPolicy: policiesDetails?['cancelPolicy']?.toString(),
      refundPolicy: policiesDetails?['refundPolicy']?.toString(),
      childPolicy: policiesDetails?['childPolicy']?.toString(),
      damagePolicy: policiesDetails?['damagePolicy']?.toString(),
      propertyRestriction: policiesDetails?['propertyRestriction']?.toString(),
      petsAllowed: policiesDetails?['petsAllowed'] as bool?,
      coupleFriendly: policiesDetails?['coupleFriendly'] as bool?,
      suitableForChildren: policiesDetails?['suitableForChildren'] as bool?,
      bachularsAllowed: policiesDetails?['bachularsAllowed'] as bool?,
      freeWifi: policiesDetails?['freeWifi'] as bool?,
      freeCancellation: policiesDetails?['freeCancellation'] as bool?,
      payAtHotel: policiesDetails?['payAtHotel'] as bool?,
      payNow: policiesDetails?['payNow'] as bool?,
      propertyMinPrice: minPriceData?['amount'] != null
          ? double.tryParse(minPriceData!['amount'].toString())
          : null,
      propertyMinPriceDisplay: minPriceData?['displayAmount']?.toString(),
      propertyMaxPrice: maxPriceData?['amount'] != null
          ? double.tryParse(maxPriceData!['amount'].toString())
          : null,
      propertyMaxPriceDisplay: maxPriceData?['displayAmount']?.toString(),
      currencySymbol: minPriceData?['currencySymbol']?.toString() ??
          maxPriceData?['currencySymbol']?.toString(),
      availableDeals: deals,
      subscriptionStatus: subscriptionData?['status'] as bool?,
      propertyView: json['propertyView'] != null
          ? int.tryParse(json['propertyView'].toString())
          : null,
      isFavorite: json['isFavorite'] as bool?,
      simplPrice: simplPriceData?['amount'] != null
          ? double.tryParse(simplPriceData!['amount'].toString())
          : null,
      simplPriceDisplay: simplPriceData?['displayAmount']?.toString(),
      originalPrice: simplPriceListData?['originalPrice'] != null
          ? double.tryParse(simplPriceListData!['originalPrice'].toString())
          : null,
    );
  }

  /// Convert HotelModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'propertyCode': id,
      'propertyName': name,
      'propertyImage': imageUrl,
      'propertyAddress': {
        'street': address,
        'city': city,
        'state': state,
        'country': country,
        'zipcode': zipcode,
        'latitude': latitude,
        'longitude': longitude,
      },
      'staticPrice': {
        'amount': price,
        'displayAmount': priceDisplay,
      },
      'markedPrice': {
        'amount': markedPrice,
      },
      'googleReview': {
        'data': {
          'overallRating': rating,
          'totalUserRating': totalReviews,
        }
      },
      'propertyStar': stars,
      'propertyType': propertyType,
      'propertyUrl': propertyUrl,
      'roomName': roomName,
      'numberOfAdults': numberOfAdults,
      'isFavorite': isFavorite,
    };
  }
}

/// Model class for Hotel Deals
class HotelDeal {
  final String? headerName;
  final String? websiteUrl;
  final String? dealType;
  final double? priceAmount;
  final String? priceDisplay;
  final String? currencySymbol;

  HotelDeal({
    this.headerName,
    this.websiteUrl,
    this.dealType,
    this.priceAmount,
    this.priceDisplay,
    this.currencySymbol,
  });

  factory HotelDeal.fromJson(Map<String, dynamic> json) {
    final priceData = json['price'] as Map<String, dynamic>?;

    return HotelDeal(
      headerName: json['headerName']?.toString(),
      websiteUrl: json['websiteUrl']?.toString(),
      dealType: json['dealType']?.toString(),
      priceAmount: priceData?['amount'] != null
          ? double.tryParse(priceData!['amount'].toString())
          : null,
      priceDisplay: priceData?['displayAmount']?.toString(),
      currencySymbol: priceData?['currencySymbol']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'headerName': headerName,
      'websiteUrl': websiteUrl,
      'dealType': dealType,
      'price': {
        'amount': priceAmount,
        'displayAmount': priceDisplay,
        'currencySymbol': currencySymbol,
      },
    };
  }
}
