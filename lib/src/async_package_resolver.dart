// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package_resolver.dart';
import 'sync_package_resolver.dart';

/// An implementation of [PackageResolver] that wraps a [SyncPackageResolver].
class AsyncPackageResolver implements PackageResolver {
  /// The wrapped [SyncPackageResolver].
  final SyncPackageResolver _inner;

  AsyncPackageResolver(this._inner);

  @override
  Future<Map<String, Uri>> get packageConfigMap async =>
      _inner.packageConfigMap;

  @override
  Future<Uri> get packageConfigUri async => _inner.packageConfigUri;
  @override
  Future<Uri> get packageRoot async => _inner.packageRoot;
  @override
  Future<SyncPackageResolver> get asSync async => _inner;
  @override
  Future<String> get processArgument async => _inner.processArgument;

  @override
  Future<Uri> resolveUri(packageUri) async => _inner.resolveUri(packageUri);
  @override
  Future<Uri> urlFor(String package, [String path]) async =>
      _inner.urlFor(package, path);
  @override
  Future<Uri> packageUriFor(url) async => _inner.packageUriFor(url);
  @override
  Future<String> packagePath(String package) async =>
      _inner.packagePath(package);
}
