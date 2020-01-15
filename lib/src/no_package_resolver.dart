// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'async_package_resolver.dart';
import 'package_resolver.dart';
import 'sync_package_resolver.dart';
import 'utils.dart';

/// A package resolution strategy that is unable to resolve any `package:` URIs.
class NoPackageResolver implements SyncPackageResolver {
  @override
  Map<String, Uri> get packageConfigMap => null;
  @override
  Uri get packageConfigUri => null;
  @override
  Uri get packageRoot => null;
  @override
  String get processArgument => null;

  @override
  PackageResolver get asAsync => AsyncPackageResolver(this);

  @override
  Uri resolveUri(packageUri) {
    // Verify that the URI is valid.
    asPackageUri(packageUri, 'packageUri');
    return null;
  }

  @override
  Uri urlFor(String package, [String path]) => null;

  @override
  Uri packageUriFor(url) {
    // Verify that the URI is a valid type.
    asUri(url, 'url');
    return null;
  }

  @override
  String packagePath(String package) => null;
}
