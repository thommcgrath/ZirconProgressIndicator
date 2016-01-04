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
		  Case "spinner"
		    Self.mIndeterminateAngle = Value
		    If Finished Then
		      Self.StartAnimation("spinner", 0, 360, Self.AnimationDuration * 3, False)
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
		  
		  Dim Size As Integer = Min(Self.Width, Self.Height)
		  Dim CancelSize As Double = Size / 4
		  Self.mCancelRect = New REALbasic.Rect(Round((Self.Width - CancelSize) / 2), Round((Self.Height - CancelSize) / 2), Round(CancelSize), Round(CancelSize))
		  
		  If Self.mCancelRect.Contains(New REALbasic.Point(X, Y)) Then
		    Self.mCancelPressed = True
		    Self.Invalidate
		    Return True
		  End If
		End Function
	#tag EndEvent

	#tag Event
		Sub MouseDrag(X As Integer, Y As Integer)
		  Dim Pressed As Boolean = Self.mCancelRect.Contains(New REALbasic.Point(X, Y))
		  If Self.mCancelPressed <> Pressed Then
		    Self.mCancelPressed = Pressed
		    Self.Invalidate
		  End If 
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseUp(X As Integer, Y As Integer)
		  Dim Pressed As Boolean = Self.mCancelRect.Contains(New REALbasic.Point(X, Y))
		  If Pressed Then
		    RaiseEvent CancelPressed
		  End If
		  Self.mCancelPressed = False
		  Self.mCancelRect = Nil
		  Self.Invalidate
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(G As Graphics, Areas() As REALbasic.Rect, ScalingFactor As Double, Highlighted As Boolean)
		  #Pragma Unused Areas
		  #Pragma Unused Highlighted
		  
		  Dim Surface As New Picture(Self.Width * ScalingFactor, Self.Height * ScalingFactor)
		  Dim Radius As Double = Min(Surface.Width, Surface.Height) / 2
		  Dim CenterX As Double = Surface.Width / 2
		  Dim CenterY As Double = Surface.Height / 2
		  Dim Rect As New REALbasic.Rect(Round(CenterX - Radius), Round(CenterY - Radius), Round(Radius * 2), Round(Radius * 2))
		  Dim InsideRect As New REALbasic.Rect(Round(CenterX - (Radius / 2)), Round(CenterY - (Radius / 2)), Round(Radius), Round(Radius))
		  
		  Surface.Graphics.ForeColor = Self.BackColor
		  Surface.Graphics.FillRect(0, 0, Surface.Width, Surface.Height)
		  Surface.Graphics.ForeColor = Self.ForeColor
		  
		  If Self.Indeterminate Then
		    Dim DegreesLow As Double = Self.mIndeterminateAngle - 30
		    Dim Degrees As Double = Self.mIndeterminateAngle
		    Dim DegreesHigh As Double = Self.mIndeterminateAngle + 30
		    Dim Distance As Double = Radius * 1.5
		    Dim RadsLow As Double = Self.DegreesToRadians(DegreesLow)
		    Dim Rads As Double = Self.DegreesToRadians(Degrees)
		    Dim RadsHigh As Double = Self.DegreesToRadians(DegreesHigh)
		    Dim Leg1X As Double = CenterX + (Distance * Cos(RadsLow))
		    Dim Leg1Y As Double = CenterY + (Distance * Sin(RadsLow))
		    Dim Leg2X As Double = CenterX + (Distance * Cos(Rads))
		    Dim Leg2Y As Double = CenterY + (Distance * Sin(Rads))
		    Dim Leg3X As Double = CenterX + (Distance * Cos(RadsHigh))
		    Dim Leg3Y As Double = CenterY + (Distance * Sin(RadsHigh))
		    
		    Dim Points(8) As Integer
		    Points(1) = Round(Leg1X)
		    Points(2) = Round(Leg1Y)
		    Points(3) = Round(Leg2X)
		    Points(4) = Round(Leg2Y)
		    Points(5) = Round(Leg3X)
		    Points(6) = Round(Leg3Y)
		    Points(7) = Round(CenterX)
		    Points(8) = Round(CenterY)
		    
		    Surface.Graphics.FillPolygon(Points)
		  Else
		    Dim Degrees As Double = 360 * ((Self.mAnimatedValue - Self.mAnimatedMinimum) / (Self.mAnimatedMaximum - Self.mAnimatedMinimum))
		    Dim StartAngle As Double
		    If Degrees >= 90 Then
		      Surface.Graphics.FillRect(Round(CenterX), Rect.Top, Round(Rect.Width / 2), Round(Rect.Height / 2))
		    ElseIf Degrees > 0 Then
		      StartAngle = 270
		    End If
		    If Degrees >= 180 Then
		      Surface.Graphics.FillRect(Round(CenterX), Round(CenterY), Round(Rect.Width / 2), Round(Rect.Height / 2))
		    ElseIf Degrees > 90 Then
		      StartAngle = 0
		    End If
		    If Degrees >= 270 Then
		      Surface.Graphics.FillRect(Rect.Left, Round(CenterY), Round(Rect.Width / 2), Round(Rect.Height / 2))
		    ElseIf Degrees > 180 Then
		      StartAngle = 90
		    End If
		    If Degrees >= 360 Then
		      Surface.Graphics.FillRect(Rect.Left, Rect.Top, Round(Rect.Width / 2), Round(Rect.Height / 2))
		    ElseIf Degrees > 270 Then
		      StartAngle = 180
		    End If
		    
		    If Degrees > 0 And Degrees < 360 Then
		      Dim Distance As Double = Radius * 1.5
		      Dim Angle1Radians As Double = Self.DegreesToRadians(Degrees - 90)
		      Dim Angle2Radians As Double = Self.DegreesToRadians(StartAngle)
		      Dim Leg1X As Double = CenterX + (Distance * Cos(Angle1Radians))
		      Dim Leg1Y As Double = CenterY + (Distance * Sin(Angle1Radians))
		      Dim Leg2X As Double = CenterX + (Distance * Cos(Angle2Radians))
		      Dim Leg2Y As Double = CenterY + (Distance * Sin(Angle2Radians))
		      
		      Dim Points(6) As Integer
		      Points(1) = Round(Leg1X)
		      Points(2) = Round(Leg1Y)
		      Points(3) = Round(Leg2X)
		      Points(4) = Round(Leg2Y)
		      Points(5) = Round(CenterX)
		      Points(6) = Round(CenterY)
		      
		      Surface.Graphics.FillPolygon(Points)
		    End If
		  End If
		  
		  Dim Mask As New Picture(Surface.Width, Surface.Height, 32)
		  Mask.Graphics.DrawPicture(Surface.CopyMask, 0, 0)
		  Mask.Mask.Graphics.ForeColor = &cFFFFFF
		  Mask.Mask.Graphics.FillRect(0, 0, Mask.Width, Mask.Height)
		  Mask.Mask.Graphics.ForeColor = &c000000
		  Mask.Mask.Graphics.FillOval(Rect.Left, Rect.Top, Rect.Width, Rect.Height)
		  Mask.Mask.Graphics.ForeColor = &cFFFFFF
		  Mask.Mask.Graphics.FillOval(InsideRect.Left, InsideRect.Top, InsideRect.Width, InsideRect.Height)
		  
		  Dim Temp As New Picture(Surface.Width, Surface.Height, 32)
		  Temp.Graphics.DrawPicture(Mask, 0, 0)
		  Surface.ApplyMask(Temp)
		  
		  If Self.CanCancel Then
		    Dim Distance As Double = Radius / 2.5
		    Dim LeftEdge As Double = CenterX + (Distance * Cos(3.92699))
		    Dim TopEdge As Double = CenterY + (Distance * Sin(3.92699))
		    Dim RightEdge As Double = CenterX + (Distance * Cos(0.785398))
		    Dim BottomEdge As Double = CenterY + (Distance * Cos(0.785398))
		    
		    Dim CancelRect As New REALbasic.Rect(Round(LeftEdge), Round(TopEdge), Round(RightEdge - LeftEdge), Round(BottomEdge - TopEdge))
		    Surface.Graphics.Transparency = 0
		    If Self.mCancelPressed Then
		      Surface.Graphics.ForeColor = RGB(Self.ForeColor.Red * 0.5, Self.ForeColor.Green * 0.5, Self.ForeColor.Blue * 0.5, Self.ForeColor.Alpha * 0.5)
		    Else
		      Surface.Graphics.ForeColor = Self.ForeColor
		    End If
		    Surface.Graphics.FillRect(CancelRect.Left, CancelRect.Top, CancelRect.Width, CancelRect.Height)
		  End If
		  
		  G.DrawPicture(Surface, 0, 0, G.Width, G.Height, 0, 0, Temp.Width, Temp.Height)
		End Sub
	#tag EndEvent

	#tag Event
		Sub ScaleFactorChanged()
		  //
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Shared Function DegreesToRadians(Degrees As Double) As Double
		  Return Degrees * 0.01745329252
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event CancelPressed()
	#tag EndHook


	#tag Property, Flags = &h0
		Animated As Boolean
	#tag EndProperty

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
			  
			  If Not Self.Animated Then
			    Self.mBackColor = Value
			    Self.Invalidate
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
			  
			  If Not Self.Animated Then
			    Self.mForeColor = Value
			    Self.Invalidate
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
			    If Value Then
			      Self.StartAnimation("spinner", 0, 360, Self.AnimationDuration * 3, False)
			    End If
			    Self.Invalidate
			  End If
			End Set
		#tag EndSetter
		Indeterminate As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Attributes( Hidden ) Private mAnimatedMaximum As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( Hidden ) Private mAnimatedMinimum As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( Hidden ) Private mAnimatedValue As Double
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
			  If Self.Animated Then
			    Self.StartAnimation("maximum", Self.mAnimatedMaximum, Value, Self.AnimationDuration)
			  Else
			    Self.mAnimatedMaximum = Value
			    Self.Invalidate
			  End If
			  
			  If Self.Value > Value Then
			    Self.Value = Value
			  End If
			End Set
		#tag EndSetter
		Maximum As Double
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Attributes( Hidden ) Private mBackColor As Color = &cFFFFFFFF
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( Hidden ) Private mCanCancel As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( Hidden ) Private mCancelPressed As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( Hidden ) Private mCancelRect As REALbasic.Rect
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( Hidden ) Private mForeColor As Color = &c4A91D5
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( Hidden ) Private mIndeterminate As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIndeterminateAngle As Double
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
			  If Self.Animated Then
			    Self.StartAnimation("minimum", Self.mAnimatedMinimum, Value, Self.AnimationDuration)
			  Else
			    Self.mAnimatedMinimum = Value
			    Self.Invalidate
			  End If
			  
			  If Self.Value < Value Then
			    Self.Value = Value
			  End If
			End Set
		#tag EndSetter
		Minimum As Double
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Attributes( Hidden ) Private mTargetMaximum As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( Hidden ) Private mTargetMinimum As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( Hidden ) Private mTargetValue As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( Hidden ) Private mTransparency As Double
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
			  Return Max(Min(Self.mTargetValue, Self.mTargetMaximum), Self.mTargetMinimum)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Value = Self.mTargetValue Then
			    Return
			  End If
			  
			  Self.mTargetValue = Value
			  If Self.Animated Then
			    Self.StartAnimation("value", Self.mAnimatedValue, Value, Self.AnimationDuration)
			  Else
			    Self.mAnimatedValue = Value
			    Self.Invalidate
			  End If
			End Set
		#tag EndSetter
		Value As Double
	#tag EndComputedProperty


	#tag Constant, Name = AnimationDuration, Type = Double, Dynamic = False, Default = \"0.25", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="AcceptFocus"
			Visible=true
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AcceptTabs"
			Visible=true
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Animated"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BackColor"
			Visible=true
			Group="Behavior"
			InitialValue="&cFFFFFFFF"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Backdrop"
			Group="Appearance"
			Type="Picture"
			EditorType="Picture"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CanCancel"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DoubleBuffer"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EraseBackground"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ForeColor"
			Visible=true
			Group="Behavior"
			InitialValue="&c4A91D5"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasFocus"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HelpTag"
			Visible=true
			Group="Appearance"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Indeterminate"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="InitialParent"
			Group="Position"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Maximum"
			Visible=true
			Group="Behavior"
			InitialValue="100"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Minimum"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Progress"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ScrollSpeed"
			Group="Behavior"
			InitialValue="20"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Transparent"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UseFocusRing"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Value"
			Visible=true
			Group="Behavior"
			InitialValue="50"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
