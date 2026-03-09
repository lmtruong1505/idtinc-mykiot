import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/features_v2/screens/chat/components/image_preview.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/style_app/init_style.dart';
import '../../../models/customer/message_zalo_model.dart';

class ItemMessage extends StatefulWidget {
  final MessageZaloModel message;
  const ItemMessage({super.key, required this.message});

  @override
  State<ItemMessage> createState() => _ItemMessageState();
}

class _ItemMessageState extends State<ItemMessage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: widget.message.isMe == true
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        if (widget.message.attachments.validator.isNotEmpty)
          Container(
            padding: 8.pading,
            margin: widget.message.messageText.isEmptyOrNull
                ? 0.pading
                : 8.padingBottom,
            decoration: BoxDecoration(
              borderRadius: 8.radiusBottom +
                  BorderRadius.only(
                    topRight:
                        Radius.circular(widget.message.isMe == true ? 0 : 8),
                    topLeft:
                        Radius.circular(widget.message.isMe == true ? 8 : 0),
                  ),
              color: ColorApp.white,
            ),
            child: StaggeredGrid.count(
              crossAxisCount: widget.message.attachments!.length > 4
                  ? 4
                  : widget.message.attachments!.length,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children: List.generate(
                widget.message.attachments!.length,
                (index) => StaggeredGridTile.count(
                  crossAxisCellCount:
                      index == 0 && widget.message.attachments!.length > 1
                          ? widget.message.attachments!.length - 1
                          : 1,
                  mainAxisCellCount:
                      index == 0 && widget.message.attachments!.length > 1
                          ? widget.message.attachments!.length - 1
                          : 1,
                  child: _buildImage(widget.message.attachments![index]),
                ),
              ),
            ),
          ),
        if (widget.message.messageText.isEmptyOrNull == false)
          Container(
            padding: 8.padingVer + 10.padingHor,
            decoration: BoxDecoration(
              borderRadius: 8.radiusBottom +
                  BorderRadius.only(
                    topRight:
                        Radius.circular(widget.message.isMe == true ? 0 : 8),
                    topLeft:
                        Radius.circular(widget.message.isMe == true ? 8 : 0),
                  ),
              color:
                  widget.message.isMe == true ? ColorApp.main : ColorApp.white,
            ),
            child: Row(
              mainAxisAlignment: widget.message.isMe == true
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    (widget.message.messageText ?? '').trim(),
                    textAlign: widget.message.isMe == true
                        ? TextAlign.right
                        : TextAlign.left,
                    style: StyleApp.normal(
                      color: widget.message.isMe == true
                          ? ColorApp.white
                          : ColorApp.black,
                    ),
                  ),
                ),
                if (widget.message.state?.icon != null) ...[
                  4.width,
                  Icon(
                    widget.message.state?.icon,
                    color: widget.message.state == StateMessage.error
                        ? ColorApp.red
                        : ColorApp.white,
                    size: 15,
                  ),
                ],
              ],
            ),
          ),
        8.height,
        // Text(
        //   message.createAt.fomatCustom(fomat: 'hh:mm:ss dd/MM/yyyy'),
        //   style: StyleApp.normal(),
        // ),
      ],
    ).padding(
      widget.message.isMe == true
          ? (context.width * 0.2).padingLeft
          : (context.width * 0.2).padingRight,
    );
  }

  Stack _buildImage(Attachments image) {
    return Stack(
      fit: StackFit.expand,
      children: [
        InkWell(
          onTap: () {
            context.bottomSheet(
              BtsImagePreview(image: image),
            );
          },
          child: image.isFile == true
              ? ClipRRect(
                  borderRadius: 4.radius,
                  child: Image.file(
                    File(
                      image.url ?? '',
                    ),
                    fit: BoxFit.cover,
                  ),
                )
              : BaseCacheImage(
                  url: image.thumbnail ?? '',
                  fit: BoxFit.cover,
                  borderRadius: 4.radius,
                ),
        ),
        if (widget.message.state == StateMessage.loading)
          Container(
            color: ColorApp.white.withOpacity(0.3),
            child: const Center(
              child: BaseLoading(
                height: 50,
              ),
            ),
          ),
        if (widget.message.state == StateMessage.error)
          Container(
            color: ColorApp.white.withOpacity(0.3),
            child: const Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 40,
                color: ColorApp.black,
              ),
            ),
          ),
      ],
    );
  }
}
