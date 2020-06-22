import 'dart:io';

import 'package:bonfire/models/bonfire.dart';
import 'package:bonfire/models/store_item.dart';
import 'package:flutter/material.dart';
import 'package:sailor/sailor.dart';

class ItemPreviewPageArgs extends BaseArguments {
  final StoreItem storeItem;

  ItemPreviewPageArgs(this.storeItem);
}

class FileArgs extends BaseArguments {
  final File file;

  FileArgs(this.file);
}

class BonfireArgs extends BaseArguments {
  final Bonfire bonfire;

  BonfireArgs(this.bonfire);
}

class VisualBonfireArgs extends BaseArguments {
  final Bonfire bonfire;
  final Color color;

  VisualBonfireArgs(this.bonfire, {this.color});
}
