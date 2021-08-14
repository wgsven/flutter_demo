import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';

ImageProvider cachedNetworkImageProvider(String url) {
  return ExtendedNetworkImageProvider(url);
}


Widget cacheImage(String url,
    {double? width,
    double? height,
    BoxFit? fit,
    bool cache = true,
    BorderRadius? borderRadius,
    BoxShape? boxShape,
    Border? border,
    bool clearMemoryCacheWhenDispose = false}) {
  return ExtendedImage.network(
    url,
    width: width,
    height: height,
    fit: fit,
    cache: cache,
    border: border,
    shape: boxShape,
    borderRadius: borderRadius,
    //图片从 tree 中移除，清掉内存缓存，以减少内存压力
    clearMemoryCacheWhenDispose: clearMemoryCacheWhenDispose,
  );
}

