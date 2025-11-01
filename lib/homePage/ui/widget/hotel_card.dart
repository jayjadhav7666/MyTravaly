import 'package:flutter/material.dart';
import 'package:my_travely/constants/colors.dart';
import 'package:my_travely/homePage/model/hotels_model.dart';

class HotelCard extends StatelessWidget {
  final Datum hotel;

  const HotelCard({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    final address = hotel.propertyAddress;
    final fullAddress =
        '${address?.street}, ${address?.city}, ${address?.state}, ${address?.country}';

    return Container(
      height: 300,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: DecorationImage(
          image: NetworkImage(hotel.propertyImage ?? ''),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 45,
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor,
              ),
              child: IconButton(
                onPressed: () {
                  // handle favorite click here
                },
                icon: const Icon(Icons.favorite_border_outlined),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotel.propertyName ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  fullAddress,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    hotel.googleReview!.reviewPresent == true
                        ? Container(
                            width: 50,
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.yellow[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '${hotel.googleReview!.data!.overallRating ?? 0}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.amber,
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(),
                    Row(
                      children: [
                        Text(
                          hotel.staticPrice?.displayAmount ?? '',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          hotel.markedPrice?.displayAmount ?? '',
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey.shade700,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
