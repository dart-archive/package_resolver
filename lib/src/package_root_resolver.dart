// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:path/path.dart' as p;

import 'async_package_resolver.dart';
import 'package_resolver.dart';
import 'sync_package_resolver.dart';
import 'utils.dart';

/// A package resolution strategy based on a package root URI.
class PackageRootResolver implements SyncPackageResolver {
  @override
  final packageConfigMap = null;
  @override
  final packageConfigUri = null;

  @override
  final Uri packageRoot;

  @override
  PackageResolver get asAsync => AsyncPackageResolver(this);

  @override
  String get processArgument => '--package-root=$packageRoot';

  PackageRootResolver(packageRoot)
      : packageRoot = ensureTrailingSlash(asUri(packageRoot, 'packageRoot'));

  @override
  Uri resolveUri(packageUri) {
    packageUri = asPackageUri(packageUri, 'packageUri');

    // Following [Isolate.resolvePackageUri], "package:foo" resolves to null.
    if (packageUri.pathSegments.length == 1) return null;
    return packageRoot.resolve(packageUri.path);
  }

  @override
  Uri urlFor(String package, [String path]) {
    var result = packageRoot.resolve('$package/');
    return path == null ? result : result.resolve(path);
  }

  @override
  Uri packageUriFor(url) {
    var packageRootString = packageRoot.toString();
    url = asUri(url, 'url').toString();
    if (!p.url.isWithin(packageRootString, url)) return null;

    var relative = p.url.relative(url, from: packageRootString);
    if (!relative.contains('/')) relative += '/';
    return Uri.parse('package:$relative');
  }

  @override
  String packagePath(String package) =>
      packagePathForRoot(package, packageRoot);
}
