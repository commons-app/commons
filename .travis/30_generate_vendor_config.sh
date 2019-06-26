#!/bin/bash
TMDB_KEY="$1"
TRAKT_ID="$2"
TRAKT_SECRET="$3"
CLAWS_URL_BETA="$4"
CLAWS_KEY_BETA="$5"
VENDOR_NAME="$6"
TRAVIS_BUILD_NUMBER="$7"

cat <<____HERE
/*
   Travis-CI - ApolloTV automated vendor configuration.
*/
import 'package:kamino/vendor/services/ClawsVendorService.dart';
import 'package:kamino/vendor/struct/VendorConfiguration.dart';
import 'package:kamino/vendor/struct/VendorService.dart';
class OfficialVendorConfiguration extends VendorConfiguration {
  OfficialVendorConfiguration() : super(
      /// The name of the vendor. If you are developing this independently,
      /// use your GitHub name.
      name: "`echo $VENDOR_NAME` (#`echo $TRAVIS_BUILD_NUMBER`)",
      /// These next options are not mandatory unless this configuration is the
      /// primary configuration.
      tmdbKey: "`echo $TMDB_KEY`",
      traktCredentials: TraktCredentials(
        id: "`echo $TRAKT_ID`",
        secret: "`echo $TRAKT_SECRET`"
      )
  );
  @override
  Future<VendorService> getService() async {
      return ClawsVendorService(
          server: "`echo $CLAWS_URL_BETA`",
          clawsKey: "`echo $CLAWS_KEY_BETA`",
          isOfficial: true,
          allowSourceSelection: true
      );
  }
}
____HERE