# ZirconProgressIndicator

Need a circular progress indicator? Need it animated, with an attached cancel button, and indeterminate state too? Need to customize the colors? ZirconProgressIndicator handles these tasks so you don't have to.

## Requirements

This control requires [Artisan Kit 1.0.1](https://github.com/thommcgrath/ArtisanKit/releases/tag/1.0.1), which requires Xojo 2015 Release 1. Only desktop projects are supported.

## Installation

Open the binary project and copy both the ZirconProgressIndicator class and ArtisanKit module into your project. If you already use Artisan Kit and encounter compile errors with the control, your ArtisanKit module needs to be updated to the included version.

## Getting Started

Drag a ZirconProgressIndicator onto a window, just like any other control. The indicator will fill the smallest dimension. This means a 100x150 control will draw a 100x100 indicator, vertically centered. The control can then be used like a standard ProgressBar control.

## Events

<pre id="event.cancelpressed"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Event</span> CancelPressed ()</span></pre>
If the cancel button has been pressed, this event will be triggered.

## Properties

<pre id="property.animated"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">Animated <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span> = <span style="color: #0000FF;">True</span></span></pre>
If true, the properties `BackColor`, `ForeColor`, `Maximum`, `Minimum`, `Value`, and `Progress` will animate their value changes. Visual changes will be applied over the next 0.25 seconds, however reading the property will immediately return the new value.

<pre id="property.backcolor"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">BackColor <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Color</span> = &amp;cFFFFFFFF</span></pre>
The background color of the fillable section of the indicator.

<pre id="property.cancancel"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">CanCancel <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span> = <span style="color: #0000FF;">True</span></span></pre>
If true, the control will draw a clickable square stop icon in the middle of the indicator. If clicked, the `CancelPressed` event will be fired.

<pre id="property.forecolor"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">ForeColor <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Color</span> = &amp;c<span style="color: #FF0000;">4A</span><span style="color: #00BB00;">91</span><span style="color: #0000FF;">D5</span></span></pre>
The fill color of the indicator.

<pre id="property.indeterminate"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">Indeterminate <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span> = <span style="color: #0000FF;">False</span></span></pre>
If true, the indicator will draw a continuous spinner to indicate that the progress cannot be predicted. Unlike the Xojo ProgressBar, the indeterminate state will not be set by making the minimum and maximum values equal. Only setting this property to true will change the state.

<pre id"property.maximum"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">Maximum <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Double</span> = <span style="color: #336698;">100</span></span></pre>
The maximum of value of the indicator. Setting the maximum lower than the current value will adjust the value too.

<pre id="property.minimum"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">Minimum <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Double</span> = <span style="color: #336698;">0</span></span></pre>
The minimum value of the indicator. Setting the minimum greater than the current value will adjust the value too.

<pre id="property.progress"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">Progress <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Double</span> = <span style="color: #006633;">0.5</span></span></pre>
Percentage of the job complete. Values < 0 or > 1 are adjusted to fit in range.

<pre id="property.value"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">Value <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Double</span> = <span style="color: #336698;">50</span></span></pre>
The numeric value of the job completion. Values outside the range of the minimum / maximum are automatically brought into range. You may use either the `Progress` property or `Value` property, depending on preference.