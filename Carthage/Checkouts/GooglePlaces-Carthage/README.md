This is a fork from  https://github.com/leoneparise/GooglePlaces-Carthage repository. I have updated it to the 2.7 version. I will try to keep it up to date with the next releases of the GMaps Libs.

Please feel free to comment or open an issue if you find any problem.

### Installation with Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate `GooglePlaces` into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "danitinez/GooglePlaces-Carthage" ~> 2.7.0
```

Run `carthage update --platform ios` to build the framework and drag the built `GoogleMaps.framework, GoogleMapsBase.framework, GoogleMapsCore.framework, GoogleMapsPlaces.framework` into your Xcode project.
