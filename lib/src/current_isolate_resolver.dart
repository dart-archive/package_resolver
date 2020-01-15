// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:isolate';

import 'package:path/path.dart' as p;

import 'package_config_resolver.dart';
import 'package_resolver.dart';
import 'package_root_resolver.dart';
import 'sync_package_resolver.dart';
import 'utils.dart';

/// The package resolution strategy used by the current isolate.
PackageResolver currentIsolateResolver() => _CurrentIsolateResolver();

class _CurrentIsolateResolver implements PackageResolver {
  @override
  Future<Map<String, Uri>> get packageConfigMap async {
    if (_packageConfigMap != null) return _packageConfigMap;

    var url = await Isolate.packageConfig;
    if (url == null) return null;

    return await loadConfigMap(url);
  }

  Map<String, Uri> _packageConfigMap;

  @override
  Future<Uri> get packageConfigUri => Isolate.packageConfig;

  // ignore: deprecated_member_use
  @override
  Future<Uri> get packageRoot => Isolate.packageRoot;

  @override
  Future<SyncPackageResolver> get asSync async {
    var root = await packageRoot;
    if (root != null) return PackageRootResolver(root);

    var map = await packageConfigMap;

    // It's hard to imagine how there would be no package resolution strategy
    // for an Isolate that can load the package_resolver package, but it's easy
    // to handle that case so we do.
    if (map == null) return SyncPackageResolver.none;

    return PackageConfigResolver(map, uri: await packageConfigUri);
  }

  @override
  Future<String> get processArgument async {
    var configUri = await packageConfigUri;
    if (configUri != null) return '--packages=$configUri';

    var root = await packageRoot;
    if (root != null) return '--package-root=$root';

    return null;
  }

  @override
  Future<Uri> resolveUri(packageUri) =>
      Isolate.resolvePackageUri(asPackageUri(packageUri, 'packageUri'));

  @override
  Future<Uri> urlFor(String package, [String path]) =>
      Isolate.resolvePackageUri(Uri.parse("package:$package/${path ?? ''}"));

  @override
  Future<Uri> packageUriFor(url) async => (await asSync).packageUriFor(url);

  @override
  Future<String> packagePath(String package) async {
    var root = await packageRoot;
    if (root != null) return PackageRootResolver(root).packagePath(package);

    return p.dirname(p.fromUri(await urlFor(package)));
  }
}
