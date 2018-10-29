# Version History

## Version 1.2.0 - October 29th, 2018

- Added support for macOS 10.14 dark mode.
- Added `AutomaticBorderColor As Boolean` property.
- Added `BorderColor As Color` property.
- Now requires Artisan Kit 1.1.0.

## Version 1.1.1 - January 27th, 2016

- Added ZirconProgressIndicator.Render shared method useful for drawing the indicator in other contexts. This method was used for building the preview found on the website.
- Added ZirconProgressIndicator.CancelStates enumeration for use with the Render shared method.

## Version 1.1 - January 26th, 2016

- Fixed issue with double-drawing the bottom-right quadrant of a filled indicator when the value was exactly 50%. This was most noticeable when using a foreground color with alpha channels.
- Demo project has the correct blue foreground color, rather than a translucent yellow-green color.
- Added a border to the indicator.
- When animation is enabled, the indicator will smoothly transition in and out of the indeterminate state.
- Updated included Artisan Kit module to version 1.0.2.
- Added version number to class. This can be found using the Version As String method or checking the Version attribute.

## Version 1.0 - January 3rd, 2016

- Initial 1.0 release.