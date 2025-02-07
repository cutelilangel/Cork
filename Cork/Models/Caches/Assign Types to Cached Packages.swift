//
//  Assign Types to Cached Packages.swift
//  Cork
//
//  Created by David Bureš - P on 16.01.2025.
//

import Foundation
import CorkShared

extension CachedPackagesTracker
{
    @MainActor
    func assignPackageTypeToCachedDownloads(brewData: BrewDataStorage)
    {
        var cachedDownloadsTracker: [CachedDownload] = .init()

        AppConstants.shared.logger.debug("Package tracker in cached download assignment function has \(brewData.installedFormulae.count + brewData.installedCasks.count) packages")

        for cachedDownload in cachedDownloads
        {
            let normalizedCachedPackageName: String = cachedDownload.packageName.onlyLetters

            if brewData.successfullyLoadedFormulae.contains(where: { $0.name.localizedCaseInsensitiveContains(normalizedCachedPackageName) })
            { /// The cached package is a formula
                AppConstants.shared.logger.debug("Cached package \(cachedDownload.packageName) (\(normalizedCachedPackageName)) is a formula")
                cachedDownloadsTracker.append(.init(packageName: cachedDownload.packageName, sizeInBytes: cachedDownload.sizeInBytes, packageType: .formula))
            }
            else if brewData.successfullyLoadedCasks.contains(where: { $0.name.localizedCaseInsensitiveContains(normalizedCachedPackageName) })
            { /// The cached package is a cask
                AppConstants.shared.logger.debug("Cached package \(cachedDownload.packageName) (\(normalizedCachedPackageName)) is a cask")
                cachedDownloadsTracker.append(.init(packageName: cachedDownload.packageName, sizeInBytes: cachedDownload.sizeInBytes, packageType: .cask))
            }
            else
            { /// The cached package cannot be found
                AppConstants.shared.logger.debug("Cached package \(cachedDownload.packageName) (\(normalizedCachedPackageName)) is unknown")
                cachedDownloadsTracker.append(.init(packageName: cachedDownload.packageName, sizeInBytes: cachedDownload.sizeInBytes, packageType: .unknown))
            }
        }

        cachedDownloads = cachedDownloadsTracker
    }
}
