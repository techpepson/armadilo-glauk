import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:glauk/core/constants/constants.dart';
import 'package:go_router/go_router.dart';

class AppBarActions extends StatefulWidget {
  const AppBarActions({super.key, required this.userImage});

  @override
  State<AppBarActions> createState() => _AppBarActionsState();

  final String userImage;
}

class _AppBarActionsState extends State<AppBarActions> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Positioned(
              top: 13,
              right: 15,
              child: Container(
                width: 9.0,
                height: 9.0,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            IconButton(
              icon: Icon(Icons.notifications_outlined),
              onPressed: () {
                context.push('/notifications');
              },
            ),
            SizedBox(width: Constants.smallSize),
          ],
        ),

        //user profile button
        CircleAvatar(
          radius: Constants.smallSize,
          child:
              widget.userImage.isNotEmpty
                  ? CachedNetworkImage(
                    imageUrl: widget.userImage,
                    errorWidget: (context, url, error) {
                      return const Icon(Icons.person);
                    },
                    placeholder: (context, url) => const Icon(Icons.person),
                  )
                  : const Icon(Icons.person),
        ),
        SizedBox(width: Constants.smallSize),
      ],
    );
  }
}
