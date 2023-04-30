

#define GPC_EPSILON (DBL_EPSILON)

#define GPC_VERSION "2.33"


/'
===========================================================================
                           Public Data Types
===========================================================================
'/

Enum gpc_op 
  GPC_DIFF,                         /' Difference                        '/
  GPC_INT,                          /' Intersection                      '/
  GPC_XOR,                          /' Exclusive or                      '/
  GPC_UNION                         /' Union                             '/
End Enum 

Type gpc_vertex 
  As Double           x            /' Vertex x component                '/
  As Double           y            /' vertex y component                '/
End Type 

Type gpc_vertex_list 
  As Long            num_vertices  /' Number of vertices in list        '/
  As gpc_vertex      Ptr vertex    /' Vertex array pointer              '/
End Type 

Type gpc_polygon 
  As Long            num_contours  /' Number of contours in polygon     '/
  As Long            Ptr hole      /' Hole / external contour flags     '/
  As gpc_vertex_list Ptr contour   /' Contour array pointer             '/
End Type 

Type gpc_tristrip 
  As Long            num_strips    /' Number of tristrips               '/
  As gpc_vertex_list Ptr strip     /' Tristrip array pointer            '/
End Type 


/'
===========================================================================
                       Public Function Prototypes Cdecl Alias "Prototypes"
===========================================================================
'/

Declare Sub gpc_read_polygon Cdecl Alias "gpc_read_polygon"(ByVal inZstring_ptr As FILE Ptr ,ByVal read_hole_flags As Long ,ByVal polygon As gpc_polygon Ptr) 

Declare Sub gpc_write_polygon Cdecl Alias "gpc_write_polygon"(ByVal outZstring_ptr As FILE Ptr ,ByVal write_hole_flags As Long ,ByVal polygon As gpc_polygon Ptr) 

Declare Sub gpc_add_contour Cdecl Alias "gpc_add_contour"(ByVal Polygon As gpc_polygon Ptr ,ByVal contour As gpc_vertex_list Ptr ,ByVal hole As Long) 

Declare Sub gpc_polygon_clip Cdecl Alias "gpc_polygon_clip"(ByVal set_operation As gpc_op ,ByVal subject_polygon As gpc_polygon Ptr ,ByVal clip_polygon As gpc_polygon Ptr ,ByVal result_polygon As gpc_polygon Ptr) 

Declare Sub gpc_tristrip_clip Cdecl Alias "gpc_tristrip_clip"(ByVal set_operation As gpc_op ,ByVal subject_polygon As gpc_polygon Ptr ,ByVal clip_polygon As gpc_polygon Ptr ,ByVal  result_tristrip As gpc_tristrip Ptr) 

Declare Sub gpc_polygon_to_tristrip Cdecl Alias "gpc_polygon_to_tristrip"(ByVal Polygon As gpc_polygon Ptr ,ByVal  tristrip As gpc_tristrip Ptr) 

Declare Sub gpc_free_polygon Cdecl Alias "gpc_free_polygon"(ByVal Polygon As gpc_polygon Ptr) 

Declare Sub gpc_free_tristrip Cdecl Alias "gpc_free_tristrip"(ByVal tristrip As gpc_tristrip Ptr) 
