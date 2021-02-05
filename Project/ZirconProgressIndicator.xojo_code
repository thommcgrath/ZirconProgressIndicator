#tag Class
Protected Class ZirconProgressIndicator
Inherits ArtisanKit.Control
	#tag Event
		Sub AnimationStep(Key As String, Value As Double, Finished As Boolean)
		  Select Case Key
		  Case "value"
		    Self.mAnimatedValue = Value
		  Case "minimum"
		    Self.mAnimatedMinimum = Value
		  Case "maximum"
		    Self.mAnimatedMaximum = Value
		  Case "fore-red"
		    Self.mForeColor = RGB(Value, Self.mForeColor.Green, Self.mForeColor.Blue, Self.mForeColor.Alpha)
		  Case "fore-green"
		    Self.mForeColor = RGB(Self.mForeColor.Red, Value, Self.mForeColor.Blue, Self.mForeColor.Alpha)
		  Case "fore-blue"
		    Self.mForeColor = RGB(Self.mForeColor.Red, Self.mForeColor.Green, Value, Self.mForeColor.Alpha)
		  Case "fore-alpha"
		    Self.mForeColor = RGB(Self.mForeColor.Red, Self.mForeColor.Green, Self.mForeColor.Blue, Value)
		  Case "back-red"
		    Self.mBackColor = RGB(Value, Self.mBackColor.Green, Self.mBackColor.Blue, Self.mBackColor.Alpha)
		  Case "back-green"
		    Self.mBackColor = RGB(Self.mBackColor.Red, Value, Self.mBackColor.Blue, Self.mBackColor.Alpha)
		  Case "back-blue"
		    Self.mBackColor = RGB(Self.mBackColor.Red, Self.mBackColor.Green, Value, Self.mBackColor.Alpha)
		  Case "back-alpha"
		    Self.mBackColor = RGB(Self.mBackColor.Red, Self.mBackColor.Green, Self.mBackColor.Blue, Value)
		  Case "border-red"
		    Self.mBorderColor = RGB(Value, Self.mBorderColor.Green, Self.mBorderColor.Blue, Self.mBorderColor.Alpha)
		  Case "border-green"
		    Self.mBorderColor = RGB(Self.mBorderColor.Red, Value, Self.mBorderColor.Blue, Self.mBorderColor.Alpha)
		  Case "border-blue"
		    Self.mBorderColor = RGB(Self.mBorderColor.Red, Self.mBorderColor.Green, Value, Self.mBorderColor.Alpha)
		  Case "border-alpha"
		    Self.mBorderColor = RGB(Self.mBorderColor.Red, Self.mBorderColor.Green, Self.mBorderColor.Blue, Value)
		  Case "angle-major"
		    Self.mMajorAngle = Value
		    If Finished And Self.Indeterminate Then
		      Var WasAnimated As Boolean = Self.Animated
		      Self.Animated = True
		      Self.StartAnimation("angle-major", -60, 300, Self.RevolutionTime, False)
		      Self.Animated = WasAnimated
		    End If
		  Case "angle-minor"
		    Self.mMinorAngle = Value
		    If Finished And Self.Indeterminate Then
		      Var WasAnimated As Boolean = Self.Animated
		      Self.Animated = True
		      Self.StartAnimation("angle-minor", -120, 240, Self.RevolutionTime, False)
		      Self.Animated = WasAnimated
		    End If
		  Else
		    Return
		  End Select
		  
		  Self.Invalidate
		End Sub
	#tag EndEvent

	#tag Event
		Function MouseDown(X As Integer, Y As Integer) As Boolean
		  If Not Self.CanCancel Then
		    Return False
		  End If
		  
		  Var Size As Integer = Min(Self.Width, Self.Height)
		  Var CancelSize As Double = Size / 4
		  Self.mCancelRect = New REALbasic.Rect(Round((Self.Width - CancelSize) / 2), Round((Self.Height - CancelSize) / 2), Round(CancelSize), Round(CancelSize))
		  
		  If Self.mCancelRect.Contains(New Xojo.Point(X, Y)) Then
		    Self.mCancelPressed = True
		    Self.Invalidate
		    Return True
		  End If
		End Function
	#tag EndEvent

	#tag Event
		Sub MouseDrag(X As Integer, Y As Integer)
		  Var Pressed As Boolean = Self.mCancelRect.Contains(New Xojo.Point(X, Y))
		  If Self.mCancelPressed <> Pressed Then
		    Self.mCancelPressed = Pressed
		    Self.Invalidate
		  End If 
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseUp(X As Integer, Y As Integer)
		  Var Pressed As Boolean = Self.mCancelRect.Contains(New Xojo.Point(X, Y))
		  If Pressed Then
		    RaiseEvent CancelPressed
		  End If
		  Self.mCancelPressed = False
		  Self.mCancelRect = Nil
		  Self.Invalidate
		End Sub
	#tag EndEvent

	#tag Event
		Sub Open()
		  RaiseEvent Open
		  Self.mReady = True
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(G As Graphics, Areas() As Xojo.Rect, Highlighted As Boolean)
		  #Pragma Unused Areas
		  #Pragma Unused Highlighted
		  
		  Var CancelState As ZirconProgressIndicator.CancelStates
		  If Self.CanCancel Then
		    If Self.mCancelPressed Then
		      CancelState = ZirconProgressIndicator.CancelStates.Pressed
		    Else
		      CancelState = ZirconProgressIndicator.CancelStates.Normal
		    End If
		  Else
		    CancelState = ZirconProgressIndicator.CancelStates.Disabled
		  End If
		  
		  Var BorderColor As Color
		  If Self.AutomaticBorderColor Then
		    Var WindowBackColor As Color = If(Color.IsDarkMode, &c25252500, &cE7E7E700)
		    Var EffectiveBackColor As Color
		    Var BackOpacity As Double = 1 - (BackColor.Alpha / 255)
		    Var RedAmount As Integer = (WindowBackColor.Red * (1 - BackOpacity)) + (BackColor.Red * BackOpacity)
		    Var GreenAmount As Integer = (WindowBackColor.Green * (1 - BackOpacity)) + (BackColor.Green * BackOpacity)
		    Var BlueAmount As Integer = (WindowBackColor.Blue * (1 - BackOpacity)) + (BackColor.Blue * BackOpacity)
		    EffectiveBackColor = RGB(RedAmount, GreenAmount, BlueAmount)
		    If ArtisanKit.ColorIsBright(EffectiveBackColor) Then
		      BorderColor = &c000000D8
		    Else
		      BorderColor = &cFFFFFFBF
		    End If
		  Else
		    BorderColor = Self.BorderColor
		  End If
		  
		  Var Pic As Picture = Self.Render(Self.Width, Self.Height, G.ScaleX, Self.mMinorAngle, Self.mMajorAngle, Self.ForeColor, Self.BackColor, BorderColor, CancelState)
		  G.DrawPicture(Pic, 0, 0, G.Width, G.Height, 0, 0, Pic.Width, Pic.Height)
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Function AngleForProgress(Progress As Double) As Double
		  Var Degrees As Double = 360 * Max(Min(Progress, 1), 0)
		  Return Degrees - 90
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CalculateDuration(FromAngle As Double, ToAngle As Double) As Double
		  Return Self.RevolutionTime * (Abs(ToAngle - FromAngle) / 360)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function DegreesToRadians(Degrees As Double) As Double
		  Return Degrees * 0.01745329252
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Render(Width As Integer, Height As Integer, ScalingFactor As Double, MinorAngle As Double, MajorAngle As Double, ForeColor As Color, BackColor As Color, BorderColor As Color, CancelState As ZirconProgressIndicator.CancelStates) As Picture
		  Var Surface As New Picture(Width * ScalingFactor, Height * ScalingFactor)
		  Var Radius As Double = Min(Surface.Width, Surface.Height) / 2
		  Var CenterX As Double = Surface.Width / 2
		  Var CenterY As Double = Surface.Height / 2
		  Var Rect As New REALbasic.Rect(Round(CenterX - Radius), Round(CenterY - Radius), Round(Radius * 2), Round(Radius * 2))
		  Var InsideRect As New REALbasic.Rect(Round(CenterX - (Radius / 2)), Round(CenterY - (Radius / 2)), Round(Radius), Round(Radius))
		  Var Distance As Double
		  
		  Surface.Graphics.DrawingColor = BackColor
		  Surface.Graphics.FillRectangle(0, 0, Surface.Width, Surface.Height)
		  
		  Surface.Graphics.DrawingColor = ForeColor
		  
		  Var Angles(0) As Double
		  Angles(0) = MinorAngle
		  For Angle As Double = MinorAngle + 45 To MajorAngle - 1 Step 45
		    #if XojoVersion >= 2020.02
		      Angles.Add(Angle)
		    #else
		      Angles.AddRow(Angle)
		    #endif
		  Next
		  #if XojoVersion >= 2020.02
		    Angles.Add(MajorAngle)
		  #else
		    Angles.AddRow(MajorAngle)
		  #endif
		  
		  Distance = Radius * 1.5
		  #if XojoVersion >= 2020.02
		    Var Path As New GraphicsPath
		    Path.MoveToPoint(Round(CenterX), Round(CenterY))
		  #else
		    Var Points(2) As Integer
		    Points(1) = Round(CenterX)
		    Points(2) = Round(CenterY)
		  #endif
		  For Each Angle As Double In Angles
		    While Angle >= 270
		      Angle = Angle - 360
		    Wend
		    Var Rads As Double = ZirconProgressIndicator.DegreesToRadians(Angle)
		    Var LegX As Double = CenterX + (Distance * Cos(Rads))
		    Var LegY As Double = CenterY + (Distance * Sin(Rads))
		    #if XojoVersion >= 2020.02
		      Path.AddLineToPoint(Round(LegX), Round(LegY))
		    #else
		      Points.AddRow(Round(LegX))
		      Points.AddRow(Round(LegY))
		    #endif
		  Next
		  
		  #if XojoVersion >= 2020.02
		    Surface.Graphics.FillPath(Path)
		  #else
		    Surface.Graphics.FillPolygon(Points)
		  #endif
		  
		  Var ShapeMask As New Picture(Surface.Width, Surface.Height)
		  ShapeMask.Graphics.DrawingColor = &cFFFFFF
		  ShapeMask.Graphics.FillRectangle(0, 0, ShapeMask.Width, ShapeMask.Height)
		  ShapeMask.Graphics.DrawingColor = &c000000
		  ShapeMask.Graphics.FillOval(Rect.Left, Rect.Top, Rect.Width, Rect.Height)
		  ShapeMask.Graphics.DrawingColor = &cFFFFFF
		  ShapeMask.Graphics.FillOval(InsideRect.Left, InsideRect.Top, InsideRect.Width, InsideRect.Height)
		  
		  Var ColorMask As Picture = Surface.CopyMask
		  ColorMask.ApplyMask(ShapeMask)
		  
		  Var Temp As New Picture(Surface.Width, Surface.Height)
		  Temp.Graphics.DrawingColor = &cFFFFFF
		  Temp.Graphics.FillRectangle(0, 0, Temp.Width, Temp.Height)
		  Temp.Graphics.DrawPicture(ColorMask, 0, 0)
		  Surface.ApplyMask(Temp)
		  
		  Surface.Graphics.DrawingColor = BorderColor
		  Surface.Graphics.PenSize = Max(Rect.Width / (37.5 * ScalingFactor), 1) * ScalingFactor
		  Surface.Graphics.DrawOval(Rect.Left, Rect.Top, Rect.Width, Rect.Height)
		  Surface.Graphics.DrawOval(InsideRect.Left - Surface.Graphics.PenSize, InsideRect.Top - Surface.Graphics.PenSize, InsideRect.Width + (Surface.Graphics.PenSize * 2), InsideRect.Height + (Surface.Graphics.PenSize * 2))
		  
		  If CancelState <> ZirconProgressIndicator.CancelStates.Disabled Then
		    Distance = Radius / 2.5
		    Var LeftEdge As Double = CenterX + (Distance * Cos(3.92699))
		    Var TopEdge As Double = CenterY + (Distance * Sin(3.92699))
		    Var RightEdge As Double = CenterX + (Distance * Cos(0.785398))
		    Var BottomEdge As Double = CenterY + (Distance * Cos(0.785398))
		    
		    Var CancelRect As New REALbasic.Rect(Round(LeftEdge), Round(TopEdge), Round(RightEdge - LeftEdge), Round(BottomEdge - TopEdge))
		    Surface.Graphics.Transparency = 0
		    If CancelState = ZirconProgressIndicator.CancelStates.Pressed Then
		      Surface.Graphics.DrawingColor = RGB(ForeColor.Red * 0.5, ForeColor.Green * 0.5, ForeColor.Blue * 0.5, ForeColor.Alpha * 0.5)
		    Else
		      Surface.Graphics.DrawingColor = ForeColor
		    End If
		    Surface.Graphics.FillRectangle(CancelRect.Left, CancelRect.Top, CancelRect.Width, CancelRect.Height)
		  End If
		  
		  Surface.HorizontalResolution = 72 * ScalingFactor
		  Surface.VerticalResolution = 72 * ScalingFactor
		  Return Surface
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Deprecated )  Shared Function Render(Width As Integer, Height As Integer, ScalingFactor As Double, MinorAngle As Double, MajorAngle As Double, ForeColor As Color, BackColor As Color, CancelState As ZirconProgressIndicator.CancelStates) As Picture
		  Return Render(Width, Height, ScalingFactor, MinorAngle, MajorAngle, ForeColor, BackColor, &c000000E4, CancelState)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetAngles(MinorAngle As Double, MajorAngle As Double, Ease As Boolean)
		  While MinorAngle < Self.mMinorAngle Or MinorAngle < Self.mMajorAngle Or MajorAngle < Self.mMinorAngle Or MajorAngle < Self.mMajorAngle
		    Self.mMinorAngle = Self.mMinorAngle - 360
		    Self.mMajorAngle = Self.mMajorAngle - 360
		  Wend
		  
		  Var Duration As Double = Self.CalculateDuration(Self.mMajorAngle, MajorAngle)
		  Self.StartAnimation("angle-minor", Self.mMinorAngle, MinorAngle, Duration, Ease)
		  Self.StartAnimation("angle-major", Self.mMajorAngle, MajorAngle, Duration, Ease)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Version() As String
		  Return "1.3"
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event CancelPressed()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Open()
	#tag EndHook


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mAutomaticBorderColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.mAutomaticBorderColor = Value Then
			    Return
			  End If
			  
			  Self.mAutomaticBorderColor = Value
			  Self.Invalidate
			End Set
		#tag EndSetter
		AutomaticBorderColor As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mBackColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.mBackColor = Value Then
			    Return
			  End If
			  
			  If Self.mBackColor.Red <> Value.Red Then
			    Self.StartAnimation("back-red", Self.mBackColor.Red, Value.Red, Self.AnimationDuration)
			  End If
			  If Self.mBackColor.Green <> Value.Green Then
			    Self.StartAnimation("back-green", Self.mBackColor.Green, Value.Green, Self.AnimationDuration)
			  End If
			  If Self.mBackColor.Blue <> Value.Blue Then
			    Self.StartAnimation("back-blue", Self.mBackColor.Blue, Value.Blue, Self.AnimationDuration)
			  End If
			  If Self.mBackColor.Alpha <> Value.Alpha Then
			    Self.StartAnimation("back-alpha", Self.mBackColor.Alpha, Value.Alpha, Self.AnimationDuration)
			  End If
			End Set
		#tag EndSetter
		BackColor As Color
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mBorderColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.mBorderColor = Value Then
			    Return
			  End If
			  
			  If Self.AutomaticBorderColor Or Self.Animated = False Then
			    Self.mBorderColor = Value
			    If Not Self.AutomaticBorderColor Then
			      Self.Invalidate
			    End If
			    Return
			  End If
			  
			  If Not Self.AutomaticBorderColor Then
			    If Self.mBorderColor.Red <> Value.Red Then
			      Self.StartAnimation("border-red", Self.mBorderColor.Red, Value.Red, Self.AnimationDuration)
			    End If
			    If Self.mBorderColor.Green <> Value.Green Then
			      Self.StartAnimation("border-green", Self.mBorderColor.Green, Value.Green, Self.AnimationDuration)
			    End If
			    If Self.mBorderColor.Blue <> Value.Blue Then
			      Self.StartAnimation("border-blue", Self.mBorderColor.Blue, Value.Blue, Self.AnimationDuration)
			    End If
			    If Self.mBorderColor.Alpha <> Value.Alpha Then
			      Self.StartAnimation("border-alpha", Self.mBorderColor.Alpha, Value.Alpha, Self.AnimationDuration)
			    End If
			  End If
			End Set
		#tag EndSetter
		BorderColor As Color
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mCanCancel
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.mCanCancel <> Value Then
			    Self.mCanCancel = Value
			    Self.Invalidate
			  End If
			End Set
		#tag EndSetter
		CanCancel As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mForeColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.mForeColor = Value Then
			    Return
			  End If
			  
			  If Self.mForeColor.Red <> Value.Red Then
			    Self.StartAnimation("fore-red", Self.mForeColor.Red, Value.Red, Self.AnimationDuration)
			  End If
			  If Self.mForeColor.Green <> Value.Green Then
			    Self.StartAnimation("fore-green", Self.mForeColor.Green, Value.Green, Self.AnimationDuration)
			  End If
			  If Self.mForeColor.Blue <> Value.Blue Then
			    Self.StartAnimation("fore-blue", Self.mForeColor.Blue, Value.Blue, Self.AnimationDuration)
			  End If
			  If Self.mForeColor.Alpha <> Value.Alpha Then
			    Self.StartAnimation("fore-alpha", Self.mForeColor.Alpha, Value.Alpha, Self.AnimationDuration)
			  End If
			End Set
		#tag EndSetter
		ForeColor As Color
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mIndeterminate
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.mIndeterminate <> Value Then
			    Self.mIndeterminate = Value
			    Var WasAnimated As Boolean = Self.Animated
			    Self.Animated = True
			    If Value Then
			      If Not Self.Animated Then
			        Self.mMinorAngle = Self.mMajorAngle - 60
			      End If
			      Self.SetAngles(-120, -60, False)
			    Else
			      Self.SetAngles(-90, Self.AngleForProgress(Self.Progress), False)
			    End If
			    Self.Animated = WasAnimated
			    Self.Invalidate
			  End If
			End Set
		#tag EndSetter
		Indeterminate As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mAnimatedMaximum As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mAnimatedMinimum As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mAnimatedValue As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mAutomaticBorderColor As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mTargetMaximum
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Value = Self.mTargetMaximum Then
			    Return
			  End If
			  
			  Self.mTargetMaximum = Value
			  Self.StartAnimation("maximum", Self.mAnimatedMaximum, Value, Self.AnimationDuration)
			  
			  If Self.Value > Value Then
			    Self.Value = Value
			  End If
			End Set
		#tag EndSetter
		Maximum As Double
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mBackColor As Color = &cFFFFFFFF
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBorderColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCanCancel As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCancelPressed As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCancelRect As Xojo.Rect
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mForeColor As Color = &c4A91D5
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIndeterminate As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mTargetMinimum
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Value = Self.mTargetMinimum Then
			    Return
			  End If
			  
			  Self.mTargetMinimum = Value
			  Self.StartAnimation("minimum", Self.mAnimatedMinimum, Value, Self.AnimationDuration)
			  
			  If Self.Value < Value Then
			    Self.Value = Value
			  End If
			End Set
		#tag EndSetter
		Minimum As Double
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mMajorAngle As Double = -90
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMinorAngle As Double = -90
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mReady As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTargetMaximum As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTargetMinimum As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTransparency As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mValue As Double
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return (Self.Value - Self.Minimum) / (Self.Maximum - Self.Minimum)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Self.Value = Self.Minimum + ((Self.Maximum - Self.Minimum) * Value)
			End Set
		#tag EndSetter
		Progress As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Max(Min(Self.mValue, Self.mTargetMaximum), Self.mTargetMinimum)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Self.mValue = Value
			  Var Angle As Double = Self.AngleForProgress(Self.Progress)
			  If Angle = Self.mMajorAngle Or Self.Indeterminate Then
			    Return
			  End If
			  
			  Self.mMinorAngle = -90
			  While Self.mMajorAngle > 270
			    Self.mMajorAngle = Self.mMajorAngle - 360
			  Wend
			  Self.StartAnimation("angle-major", Self.mMajorAngle, Angle, Self.CalculateDuration(Self.mMajorAngle, Angle))
			  Self.Invalidate
			End Set
		#tag EndSetter
		Value As Double
	#tag EndComputedProperty


	#tag Constant, Name = AnimationDuration, Type = Double, Dynamic = False, Default = \"0.3", Scope = Private, Attributes = \""
	#tag EndConstant

	#tag Constant, Name = RevolutionTime, Type = Double, Dynamic = False, Default = \"0.75", Scope = Private, Attributes = \""
	#tag EndConstant


	#tag Enum, Name = CancelStates, Type = Integer, Flags = &h0
		Disabled
		  Normal
		Pressed
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="AllowAutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Tooltip"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocusRing"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocus"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowTabs"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="InitialParent"
			Visible=false
			Group="Position"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Visible=false
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Backdrop"
			Visible=false
			Group="Appearance"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="NeedsFullKeyboardAccessForFocus"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Animated"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BackColor"
			Visible=true
			Group="Behavior"
			InitialValue="&cFFFFFFFF"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CanCancel"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DoubleBuffer"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ForeColor"
			Visible=true
			Group="Behavior"
			InitialValue="&c4A91D5"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasFocus"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Indeterminate"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Maximum"
			Visible=true
			Group="Behavior"
			InitialValue="100"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Minimum"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Progress"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ScrollSpeed"
			Visible=false
			Group="Behavior"
			InitialValue="20"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Transparent"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Value"
			Visible=true
			Group="Behavior"
			InitialValue="50"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AutomaticBorderColor"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BorderColor"
			Visible=true
			Group="Behavior"
			InitialValue="&c000000E4"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
