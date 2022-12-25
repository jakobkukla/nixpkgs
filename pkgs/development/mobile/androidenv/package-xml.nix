{ package, licenseText }:

let
  version = builtins.splitVersion package.revision;
  l = builtins.length version;

  major = if (l >= 1) then builtins.elemAt version 0 else null;
  minor = if (l >= 2) then builtins.elemAt version 1 else null;
  micro = if (l >= 3) then builtins.elemAt version 2 else null;
  # FIXME: missing preview

  path = builtins.replaceStrings [ "/" ] [ ";" ] package.path;
in
''
  <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
  <ns2:repository xmlns:ns2="http://schemas.android.com/repository/android/common/02" xmlns:ns3="http://schemas.android.com/repository/android/common/01" xmlns:ns4="http://schemas.android.com/repository/android/generic/01" xmlns:ns5="http://schemas.android.com/repository/android/generic/02" xmlns:ns6="http://schemas.android.com/sdk/android/repo/addon2/01" xmlns:ns7="http://schemas.android.com/sdk/android/repo/addon2/02" xmlns:ns8="http://schemas.android.com/sdk/android/repo/addon2/03" xmlns:ns9="http://schemas.android.com/sdk/android/repo/repository2/01" xmlns:ns10="http://schemas.android.com/sdk/android/repo/repository2/02" xmlns:ns11="http://schemas.android.com/sdk/android/repo/repository2/03" xmlns:ns12="http://schemas.android.com/sdk/android/repo/sys-img2/03" xmlns:ns13="http://schemas.android.com/sdk/android/repo/sys-img2/02" xmlns:ns14="http://schemas.android.com/sdk/android/repo/sys-img2/01">
  <license id="${package.license}" type="text">${
    licenseText
  }</license>
  <localPackage path="${path}" obsolete="false"><type-details xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="ns5:genericDetailsType"/>
    <revision>
      ${if (major != null) then "<major>${major}</major>" else ""}
      ${if (minor != null) then "<minor>${minor}</minor>" else ""}
      ${if (micro != null) then "<micro>${micro}</micro>" else ""}
    </revision>
    <display-name>${package.displayName}</display-name><uses-license ref="${package.license}"/>
  </localPackage>#
  </ns2:repository>
''

