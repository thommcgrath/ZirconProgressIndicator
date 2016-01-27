#tag Module
Protected Module PreviewBuilder
	#tag Method, Flags = &h21
		Private Sub AppendAngles(MinorAngles() As Double, MajorAngles() As Double, StartMinor As Double, StartMajor As Double, EndMinor As Double, EndMajor As Double)
		  Dim MinorDiff As Double = EndMinor - StartMinor
		  Dim MajorDiff As Double = EndMajor - StartMajor
		  Dim Steps As Double = Max(Abs(MinorDiff), Abs(MajorDiff)) / 10
		  
		  Dim MinorValuePerStep As Double = MinorDiff / Steps
		  Dim MajorValuePerStep As Double = MajorDiff / Steps
		  
		  For I As Integer = 0 To Steps - 1
		    MinorAngles.Append(StartMinor + (MinorValuePerStep * I))
		    MajorAngles.Append(StartMajor + (MajorValuePerStep * I))
		  Next
		  
		  MinorAngles.Append(EndMinor)
		  MajorAngles.Append(EndMajor)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Generate(Size As Integer, Destination As FolderItem)
		  If Not Destination.Exists Then
		    Destination.CreateAsFolder
		  End If
		  
		  Dim MinorKeyframes() As Integer = Array(-90, -90)
		  Dim MajorKeyframes() As Integer = Array(-90, 270)
		  
		  Dim MinorAngles(), MajorAngles() As Double
		  
		  // Fill progress
		  AppendAngles(MinorAngles, MajorAngles, -90, -90, -90, 270)
		  
		  // Transition full to indeterminate
		  AppendAngles(MinorAngles, MajorAngles, -450, -90, -120, -60)
		  
		  // Full revolution indeterminate x3
		  AppendAngles(MinorAngles, MajorAngles, -120, -60, 240, 300)
		  AppendAngles(MinorAngles, MajorAngles, -120, -60, 240, 300)
		  AppendAngles(MinorAngles, MajorAngles, -120, -60, 240, 300)
		  
		  // Transition indeterminate to empty
		  AppendAngles(MinorAngles, MajorAngles, -120, -60, 270, 270)
		  
		  // Remove duplicate frames (reverse order)
		  Dim Duplicates() As Integer = Array(221, 182, 145, 108, 71)
		  For Each Index As Integer In Duplicates
		    MinorAngles.Remove(Index)
		    MajorAngles.Remove(Index)
		  Next
		  
		  // Render them
		  Dim Factors() As Double = Array(1.0, 2.0, 3.0)
		  For Each Factor As Integer In Factors
		    Dim SizeFolder As FolderItem = Destination.Child(Str(Factor, "-0"))
		    If Not SizeFolder.Exists Then
		      SizeFolder.CreateAsFolder
		    End If
		    
		    For I As Integer = 0 To UBound(MajorAngles)
		      Dim MinorAngle As Integer = MinorAngles(I)
		      Dim MajorAngle As Integer = MajorAngles(I)
		      Dim Frame As Picture = ZirconProgressIndicator.Render(Size, Size, Factor, MinorAngle, MajorAngle, &c4A91D5, &cCCCCCC, ZirconProgressIndicator.CancelStates.Normal)
		      
		      Dim GIF As New Picture(Frame.Width, Frame.Height, 32)
		      GIF.Graphics.DrawPicture(Frame, 0, 0)
		      GIF.Save(SizeFolder.Child("indicator_" + Str(I, "000") + ".png"), Picture.SaveAsPNG)
		    Next
		  Next
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
