	#Inclib "gpc"
	
		#Include "crt\stdio.bi" ' printf(), scanf(), fopen(), etc
	
	#Include "gpc.bi"
	
	Dim Shared As Integer anchow=800	
	Dim Shared As Integer altow =600

	Screenres anchow,altow,32 ' 800x600 RGB32
	window (0,0)-(anchow,altow) ' establece el origen (0,0) de coordenadas, arriba a la izquierda
	
	
	Dim As String  sa,sb,sc,sd ' cadenas
	
	Dim As Double  da,db,dc,dd ' 8 bytes
	
	Dim As Integer a,b,c,d,e,f,g ' 8 bytes
	
	Dim Shared As Integer agujero=0 ' indica a la rutina de recortes, si tratamos agujeros o no
	
	Dim Shared As Double escala=0,origenx,origeny
	
Function quita_tabs(aa As string) As String
	For f As Integer=1 To Len(aa)
		If Mid(aa,f,1)=Chr(9) Then Mid(aa,f,1)=" "
	Next
	return aa
End Function

	Dim Shared As Double xmax,xmin,ymax,ymin
	xmin= 99999
	xmax=-99999
	ymin= 99999
	ymax=-99999	


Sub lee_polygono(aa As String, mm() As gpc_vertex)
	Dim As String  sa,sb
	Dim As Integer a,f,e
	Dim As Double  xx,yy
	Dim As Integer npol
	Dim As Integer nvert
	Dim As Integer tipo ' 0=no agujero, 1=agujero

	
	Open aa For Input As 1
		Line Input #1,sa:sa=quita_tabs(sa)
		npol=Val(Trim(sa)) ' numero de poligonos a leer (desde 1)
		a=0
		For f=1 To npol
			Line Input #1,sa:sa=quita_tabs(sa) ' numero de vertices del poligono
			nvert=Val(Trim(sa))
			Line Input #1,sa:sa=quita_tabs(sa) ' ¿agujero? si existe solo UN valor, es SI (TRUE), si vienen DOS datos, entonces es NO (FALSE)
			' compruebo se es UNO o DOS los valores
			sa=Trim(sa)
			If InStr(sa," ")>1 Then ' DOS coordenadas separadas por un ESPACIO, por lo tanto, me salto TIPO 
				tipo=-1 ' no existe
			Else
				tipo=Val(sa) ' existe, puede ser 1 o 0
			EndIf
			if tipo=1 then agujero=1 ' existe agujero
			mm(a).x=tipo:a+=1
			For e=1 To nvert
				If tipo=-1 Then
					tipo=-2 ' para que no se repita
				Else
					Line Input #1,sa:sa=quita_tabs(sa)
				EndIf
				sa=LTrim(sa)
				xx=Val(sa)
				sa=Mid(sa,InStr(sa," ")+1)
				yy=Val(sa)
				mm(a).x=xx
				mm(a).y=yy
				If xx<xmin Then xmin=xx
				If xx>xmax Then xmax=xx
				If yy<ymin Then ymin=yy
				If yy>ymax Then ymax=yy
				a+=1
			Next
			mm(a).x=9999 ' fin de poligono
			a+=1
		Next
		mm(a).y=9999 ' fin de todo
	Close 1
	
	'If escala Then Exit Sub
	xx=Abs(xmax-xmin)
	yy=Abs(ymax-ymin)
	
	xx=(anchow-100)/xx ' ancho de pantalla con un borde de 50 alrededor
	yy=( altow-100)/yy ' alto de pantalla con borde de 50 de mas
	If xx<yy Then 
		escala=xx
	Else 
		escala=yy
	EndIf

	origenx=(xmin*escala)-((anchow-(Abs(xmax-xmin)*escala))/2)
	origeny=(ymin*escala)-(( altow-(Abs(ymax-ymin)*escala))/2)
	
End Sub

Sub dibuja_poligono(mm() As gpc_vertex, Color_ As UInteger, escala As double)
	Dim As Integer npol

	Dim As double xx,yy,xx2,yy2,xxi,yyi
	
	Dim As Integer g=0
	Dim As Integer f,e

	While 1
		'color_=IIf(mm(g).x=1,RGB(255,255,255), color_) ' segun si tipo es agujero(1) o no(0) un color u otro
		xx2=(mm(g+1).x)*escala-origenx
		yy2=(mm(g+1).y)*escala-origeny
		xxi=xx2:yyi=yy2
		For f=g+2 To 2000
			xx=(mm(f).x)*escala-origenx
			yy=(mm(f).y)*escala-origeny
			If mm(f).x=9999 Then 
				Line(xx2,yy2)-(xxi,yyi),color_	
				Exit For
			EndIf
			Line(xx2,yy2)-(xx,yy),color_		
			xx2=xx:yy2=yy
		Next
		If mm(f+1).y=9999 Then Exit While
		g=f+1
	Wend	
End Sub
	

	Dim As String poligonos_a="simple1.txt"
	Dim As String poligonos_b="simple2.txt"
	
	
	Dim As gpc_vertex m1(2000)
	lee_polygono(poligonos_a,m1())

	Dim As gpc_vertex m2(2000)
	lee_polygono(poligonos_b,m2())
	
	' dibujamos ambos poligonos
	dibuja_poligono(m1(),RGB(255,0,0),escala)	
	dibuja_poligono(m2(),RGB(0,0,255),escala)		
	
	
	' --------------------------------------------------------------
	         Dim As gpc_polygon subject, clip, result
            Dim As FILE Ptr sfp, cfp, ofp
    
            sfp= fopen(poligonos_a, "r")
            cfp= fopen(poligonos_b, "r")
            gpc_read_polygon(sfp, agujero, @subject)
            gpc_read_polygon(cfp, agujero, @clip)
    
    			' cuatro modos diferentes
      		' GPC_DIFF  Difference
  				' GPC_INT   Intersection
  				' GPC_XOR   Exclusive Or
  				' GPC_UNION union
            gpc_polygon_clip(GPC_UNION, @subject, @clip, @result)

            ofp= fopen("resultado.txt", "w")
            gpc_write_polygon(ofp, agujero, @result)
    
            gpc_free_polygon(@subject)
            gpc_free_polygon(@clip)
            gpc_free_polygon(@result)
          
            fclose(sfp)
            fclose(cfp)
            fclose(ofp)
	' --------------------------------------------------------------
	

	Print "Pulsa una tecla para ver el resultado":sleep

	Dim As gpc_vertex m3(5000)
	lee_polygono("resultado.txt",m3())
	dibuja_poligono(m3(),RGB(0,255,0),escala)	
	
	
	Sleep