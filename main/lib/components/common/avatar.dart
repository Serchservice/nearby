import 'package:flutter/widgets.dart';
import 'package:drive/library.dart';
import 'package:smart/ui.dart';

class Avatar extends BaseAvatar {
  Avatar({
    super.key,
    required super.radius,
    String avatar = "",
    super.onClick
  }) : super(
    foregroundImageBuilder: (BuildContext context, String fallback) {
      return AssetUtility.image(avatar, fallback: fallback);
    },
  );

  Avatar.large({
    super.key,
    String avatar = "",
    super.onClick
  }) : super(
    foregroundImageBuilder: (BuildContext context, String fallback) {
      return AssetUtility.image(avatar, fallback: fallback);
    },
    radius: 50
  );

  Avatar.medium({
    super.key,
    String avatar = "",
    super.onClick
  }) : super(
    foregroundImageBuilder: (BuildContext context, String fallback) {
      return AssetUtility.image(avatar, fallback: fallback);
    },
    radius: 30
  );

  Avatar.small({
    super.key,
    String avatar = "",
    super.onClick
  }) : super(
    foregroundImageBuilder: (BuildContext context, String fallback) {
      return AssetUtility.image(avatar, fallback: fallback);
    },
    radius: 15
  );
}

class StackedAvatars extends BaseStackedAvatars<String> {
  StackedAvatars({
    super.key,
    super.totalAvatarsInView,
    required super.avatars,
    super.avatarSize = 40.0,
    bool isLoading = false,
  }) : super(
    itemBuilder: (BuildContext context, metadata) {
      if(isLoading) {
        return Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            color: CommonColors.instance.shimmerHigh,
            shape: BoxShape.circle
          )
        );
      } else {
        return Avatar(radius: avatarSize / 2, avatar: metadata.item);
      }
    }
  );
}